import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:movie_stream_app/src/core/constants/app_constants.dart';
import 'package:movie_stream_app/src/core/theme/app_colors.dart';
import 'package:movie_stream_app/src/core/theme/app_typography.dart';
import 'package:movie_stream_app/src/logic/favorites/favorites_bloc.dart';
import 'package:movie_stream_app/src/logic/favorites/favorites_event.dart';
import 'package:movie_stream_app/src/logic/favorites/favorites_state.dart';
import 'package:movie_stream_app/src/presentation/movie_detail/ui/enhanced_movie_detail_screen.dart';
import 'package:movie_stream_app/src/presentation/shared/widgets/enhanced_search_result_card.dart';
import 'package:movie_stream_app/src/presentation/shared/widgets/error_display.dart';
import 'package:movie_stream_app/src/presentation/shared/widgets/shimmer_widget.dart';

class EnhancedFavoritesScreen extends StatefulWidget {
  const EnhancedFavoritesScreen({super.key});

  @override
  State<EnhancedFavoritesScreen> createState() =>
      _EnhancedFavoritesScreenState();
}

class _EnhancedFavoritesScreenState extends State<EnhancedFavoritesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadFavorites();
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

  void _loadFavorites() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesBloc>().add(const FavoritesRequested());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = context.watch<FavoritesBloc>().state;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradientPrimary,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(favoritesState),
              Expanded(child: _buildContent(favoritesState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(FavoritesState state) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: -50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Watchlist',
                            style: AppTypography.textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${state.movies.length} ${state.movies.length == 1 ? 'movie' : 'movies'}',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.movies.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMedium,
                          ),
                        ),
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
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(FavoritesState state) {
    if (state.isLoading) {
      return _buildLoadingState();
    }

    if (state.error != null) {
      return _buildErrorState(state.error!);
    }

    if (state.movies.isEmpty) {
      return _buildEmptyState();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedSwitcher(
        duration: AppConstants.animationMedium,
        child: _isGridView ? _buildGridView(state) : _buildListView(state),
      ),
    );
  }

  Widget _buildLoadingState() {
    return AnimationLimiter(
      child: Column(
        children: List.generate(
          5,
          (index) => AnimationConfiguration.staggeredList(
            position: index,
            duration: AppConstants.animationMedium,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingSmall,
                  ),
                  child: const SearchResultShimmer(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ErrorDisplay(message: error),
            const SizedBox(height: AppConstants.paddingLarge),
            ElevatedButton.icon(
              onPressed: _loadFavorites,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
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
                Icons.favorite_border_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              'Your Watchlist is Empty',
              style: AppTypography.textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'Start building your collection by adding\nmovies and series you want to watch.',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.explore),
              label: const Text('Discover Movies'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(FavoritesState state) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
        ),
        itemCount: state.movies.length,
        itemBuilder: (context, index) {
          final movie = state.movies[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AppConstants.animationMedium,
            child: SlideAnimation(
              horizontalOffset: -50.0,
              child: FadeInAnimation(
                child: Dismissible(
                  key: Key(movie.imdbID),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(
                      right: AppConstants.paddingLarge,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusLarge,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Remove',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    _removeFavorite(movie.imdbID);
                    _showRemovedSnackBar(movie.title);
                  },
                  child: EnhancedSearchResultCard(
                    title: movie.title,
                    posterUrl: movie.poster,
                    year: movie.year,
                    type: movie.type,
                    rating: 0.0,
                    plot: null,
                    index: index,
                    onTap: () => _navigateToMovieDetail(movie.imdbID),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(FavoritesState state) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppConstants.paddingMedium,
          crossAxisSpacing: AppConstants.paddingMedium,
          childAspectRatio: 0.65,
        ),
        itemCount: state.movies.length,
        itemBuilder: (context, index) {
          final movie = state.movies[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: AppConstants.animationMedium,
            columnCount: 2,
            child: ScaleAnimation(
              scale: 0.5,
              child: FadeInAnimation(
                child: SearchResultGrid(
                  title: movie.title,
                  posterUrl: movie.poster,
                  year: movie.year,
                  type: movie.type,
                  index: index,
                  onTap: () => _navigateToMovieDetail(movie.imdbID),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _removeFavorite(String imdbId) {
    context.read<FavoritesBloc>().add(FavoriteRemoved(imdbId));
  }

  void _showRemovedSnackBar(String movieTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$movieTitle removed from watchlist'),
        backgroundColor: AppColors.surfaceContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // TODO: Implement undo functionality
          },
        ),
      ),
    );
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
