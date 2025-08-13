import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:movie_stream_app/src/core/constants/app_constants.dart';
import 'package:movie_stream_app/src/core/theme/app_colors.dart';
import 'package:movie_stream_app/src/core/theme/app_typography.dart';
import 'package:movie_stream_app/src/logic/movie_search/movie_search_bloc.dart';
import 'package:movie_stream_app/src/logic/movie_search/movie_search_event.dart';
import 'package:movie_stream_app/src/logic/movie_search/movie_search_state.dart';
import 'package:movie_stream_app/src/presentation/movie_detail/ui/enhanced_movie_detail_screen.dart';
import 'package:movie_stream_app/src/presentation/shared/widgets/app_search_bar.dart';
import 'package:movie_stream_app/src/presentation/shared/widgets/enhanced_search_result_card.dart';
import 'package:movie_stream_app/src/presentation/shared/widgets/error_display.dart';
import 'package:movie_stream_app/src/presentation/shared/widgets/shimmer_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isGridView = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupScrollListener();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationMedium,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final state = context.read<MovieSearchBloc>().state;
        if (!state.isLoadingMore &&
            !state.hasReachedMax &&
            _currentQuery.isNotEmpty) {
          context.read<MovieSearchBloc>().add(const MovieSearchLoadMore());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = context.watch<MovieSearchBloc>().state;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradientPrimary,
          ),
        ),
        child: AnimationLimiter(
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildSearchHeader(),
              const SizedBox(height: AppConstants.paddingLarge),
              Expanded(child: _buildSearchContent(searchState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: -50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchBar(
                        controller: _searchController,
                        focusNode: _focusNode,
                        hintText: 'Search movies, series, episodes...',
                        autofocus: true,
                        onFilterTap: () => _toggleViewMode(),
                        onChanged: (query) => _performSearch(query),
                        onSubmitted: (query) => _performSearch(query),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    AnimatedContainer(
                      duration: AppConstants.animationFast,
                      child: IconButton(
                        onPressed: _toggleViewMode,
                        icon: AnimatedSwitcher(
                          duration: AppConstants.animationFast,
                          child: Icon(
                            _isGridView ? Icons.list : Icons.grid_view,
                            key: ValueKey(_isGridView),
                            color: AppColors.primary,
                          ),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_currentQuery.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.paddingMedium),
                  Row(
                    children: [
                      Text(
                        'Search results for ',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '"$_currentQuery"',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchContent(MovieSearchState state) {
    if (_currentQuery.isEmpty) {
      return _buildEmptyState();
    }

    if (state.isLoading && state.movies.isEmpty) {
      return _buildLoadingState();
    }

    if (state.error != null && state.movies.isEmpty) {
      return Center(child: ErrorDisplay(message: state.error!));
    }

    if (state.movies.isEmpty) {
      return _buildNoResultsState();
    }

    return AnimatedSwitcher(
      duration: AppConstants.animationMedium,
      child: _isGridView ? _buildGridView(state) : _buildListView(state),
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                shape: BoxShape.circle,
                boxShadow: const [AppColors.shadowMedium],
              ),
              child: const Icon(
                Icons.movie_filter_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              'Discover Movies & Series',
              style: AppTypography.textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'Search for your favorite movies, series, and episodes\nfrom our extensive collection.',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return _isGridView
        ? GridView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppConstants.paddingMedium,
              crossAxisSpacing: AppConstants.paddingMedium,
              childAspectRatio: 0.65,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => ShimmerWidget(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppConstants.radiusLarge,
            ),
          )
        : ListShimmer(itemCount: 5, shimmerItem: const SearchResultShimmer());
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_outlined,
              size: 40,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Text(
            'No Results Found',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Try adjusting your search terms\nor browse our collection.',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListView(MovieSearchState state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.movies.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.movies.length) {
          return Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: ShimmerWidget(
              width: double.infinity,
              height: 100,
              borderRadius: AppConstants.radiusLarge,
            ),
          );
        }

        final movie = state.movies[index];
        return EnhancedSearchResultCard(
          title: movie.title,
          posterUrl: movie.poster,
          year: movie.year,
          type: movie.type,
          rating: 0.0,
          plot: null,
          index: index,
          onTap: () => _navigateToMovieDetail(movie.imdbID),
        );
      },
    );
  }

  Widget _buildGridView(MovieSearchState state) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppConstants.paddingMedium,
        crossAxisSpacing: AppConstants.paddingMedium,
        childAspectRatio: 0.65,
      ),
      itemCount: state.movies.length + (state.isLoadingMore ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= state.movies.length) {
          return ShimmerWidget(
            width: double.infinity,
            height: double.infinity,
            borderRadius: AppConstants.radiusLarge,
          );
        }

        final movie = state.movies[index];
        return SearchResultGrid(
          title: movie.title,
          posterUrl: movie.poster,
          year: movie.year,
          type: movie.type,
          index: index,
          onTap: () => _navigateToMovieDetail(movie.imdbID),
        );
      },
    );
  }

  void _performSearch(String query) {
    setState(() {
      _currentQuery = query.trim();
    });

    if (_currentQuery.isNotEmpty) {
      context.read<MovieSearchBloc>().add(MovieSearchRequested(_currentQuery));
    } else {
      context.read<MovieSearchBloc>().add(const MovieSearchRequested(''));
    }
  }

  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _navigateToMovieDetail(String imdbId) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, _) =>
            EnhancedMovieDetailScreen(imdbID: imdbId),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
            child: child,
          );
        },
        transitionDuration: AppConstants.pageTransitionDuration,
      ),
    );
  }
}
