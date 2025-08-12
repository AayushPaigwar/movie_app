import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/movie_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/enhanced_genre_chip.dart';
import '../widgets/enhanced_movie_card.dart';
import '../widgets/error_display.dart';
import '../widgets/shimmer_widget.dart';
import 'filter_screen.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _featuredQueries = [
    'avengers',
    'batman',
    'spider',
    'marvel',
  ];
  // Removed unused _currentFeaturedIndex

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollListener();
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieSearchProvider.notifier).searchMovies(_featuredQueries[0]);
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final state = ref.read(movieSearchProvider);
        if (!state.isLoadingMore && !state.hasReachedMax) {
          ref
              .read(movieSearchProvider.notifier)
              .searchMovies(state.query, loadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradientPrimary,
          ),
        ),
        child: AnimationLimiter(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    _buildSearchBar(),
                    const SizedBox(height: AppConstants.paddingLarge),
                    _buildGenreChips(),
                    const SizedBox(height: AppConstants.paddingLarge),
                    _buildFeaturedCarousel(),
                    const SizedBox(height: AppConstants.paddingLarge),
                    _buildSectionHeader('Trending Now'),
                    _buildMovieHorizontalList('trending'),
                    const SizedBox(height: AppConstants.paddingLarge),
                    _buildSectionHeader('Popular Movies'),
                    _buildMovieHorizontalList('popular'),
                    const SizedBox(height: AppConstants.paddingLarge),
                    _buildSectionHeader('Top Rated'),
                    _buildMovieHorizontalList('topRated'),
                    const SizedBox(height: AppConstants.paddingExtraLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: -50.0,
        child: FadeInAnimation(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
            ),
            child: AppSearchBar(
              onFilterTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, _) =>
                        const FilterScreen(),
                    transitionsBuilder: (context, animation, _, child) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeInOut)),
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: AppConstants.pageTransitionDuration,
                  ),
                );
              },
              onChanged: (query) {
                if (query.isNotEmpty) {
                  ref.read(movieSearchProvider.notifier).searchMovies(query);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenreChips() {
    final selectedGenre = ref.watch(currentGenreProvider);

    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: GenreChipsList(
            genres: AppConstants.genres.take(8).toList(),
            selectedGenre: selectedGenre,
            onGenreSelected: (genre) {
              ref.read(currentGenreProvider.notifier).state = genre;
              if (genre == 'All') {
                ref
                    .read(movieSearchProvider.notifier)
                    .searchMovies(_featuredQueries[0]);
              } else {
                ref
                    .read(movieSearchProvider.notifier)
                    .searchMovies(genre.toLowerCase());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    final movieState = ref.watch(movieSearchProvider);

    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: SizedBox(
            height: AppConstants.carouselHeight,
            child: movieState.isLoading
                ? const CarouselShimmer()
                : movieState.error != null
                ? Center(child: ErrorDisplay(message: movieState.error!))
                : CarouselSlider(
                    options: CarouselOptions(
                      height: AppConstants.carouselHeight,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      autoPlayCurve: Curves.easeInOutCubic,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      viewportFraction: 0.85,
                      aspectRatio: AppConstants.carouselAspectRatio,
                    ),
                    items: movieState.movies.take(5).map((movie) {
                      final index = movieState.movies.indexOf(movie);
                      return EnhancedCarouselCard(
                        title: movie.title,
                        posterUrl: movie.poster,
                        description:
                            '${movie.year} • ${movie.type.toUpperCase()}',
                        index: index,
                        onTap: () => _navigateToMovieDetail(
                          movie.imdbID,
                          heroTag: 'home_movie_${movie.imdbID}',
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return AnimationConfiguration.staggeredList(
      position: 3,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        horizontalOffset: -50.0,
        child: FadeInAnimation(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
              vertical: AppConstants.paddingSmall,
            ),
            child: Text(
              title,
              style: AppTypography.sectionHeader.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieHorizontalList(String sectionKey) {
    final movieState = ref.watch(movieSearchProvider);

    return AnimationConfiguration.staggeredList(
      position: 4,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        horizontalOffset: 100.0,
        child: FadeInAnimation(
          child: SizedBox(
            height: AppConstants.movieCardHeight + 60,
            child: movieState.isLoading
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index) => const MovieCardShimmer(),
                  )
                : movieState.error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: ErrorDisplay(message: movieState.error!),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                    ),
                    itemCount: movieState.movies.length,
                    itemBuilder: (context, index) {
                      final movie = movieState.movies[index];
                      return EnhancedMovieCard(
                        title: movie.title,
                        posterUrl: movie.poster,
                        year: movie.year,
                        genre: movie.type,
                        rating: 0.0,
                        index: index,
                        isHero: true,
                        heroTag: 'home_${sectionKey}_${movie.imdbID}',
                        onTap: () => _navigateToMovieDetail(
                          movie.imdbID,
                          heroTag: 'home_${sectionKey}_${movie.imdbID}',
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  void _navigateToMovieDetail(String imdbId, {String? heroTag}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, _) =>
            MovieDetailScreen(imdbID: imdbId, heroTag: heroTag),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
            child: child,
          );
        },
        transitionDuration: AppConstants.heroTransitionDuration,
      ),
    );
  }
}
