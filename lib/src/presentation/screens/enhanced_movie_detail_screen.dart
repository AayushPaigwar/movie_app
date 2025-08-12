import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/providers/movie_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/shimmer_widget.dart';
import '../widgets/error_display.dart';

class EnhancedMovieDetailScreen extends ConsumerStatefulWidget {
  final String imdbID;
  final String? heroTag;

  const EnhancedMovieDetailScreen({
    super.key,
    required this.imdbID,
    this.heroTag,
  });

  @override
  ConsumerState<EnhancedMovieDetailScreen> createState() => _EnhancedMovieDetailScreenState();
}

class _EnhancedMovieDetailScreenState extends ConsumerState<EnhancedMovieDetailScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  double _scrollOffset = 0.0;
  static const double _expandedHeight = 350.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupScrollListener();
    _loadMovieDetails();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationMedium,
      vsync: this,
    );
    
    _fabAnimationController = AnimationController(
      duration: AppConstants.animationFast,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _fabAnimationController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  void _loadMovieDetails() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieDetailProvider.notifier).loadMovieDetail(widget.imdbID);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieDetailState = ref.watch(movieDetailProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradientPrimary,
          ),
        ),
        child: movieDetailState.isLoading
            ? _buildLoadingState()
            : movieDetailState.error != null
                ? _buildErrorState(movieDetailState.error!)
                : movieDetailState.movie != null
                    ? _buildMovieDetails(movieDetailState, screenSize)
                    : const SizedBox.shrink(),
      ),
      floatingActionButton: movieDetailState.movie != null
          ? ScaleTransition(
              scale: _scaleAnimation,
              child: FloatingActionButton.extended(
                onPressed: () => _toggleFavorite(),
                backgroundColor: movieDetailState.isFavorite
                    ? AppColors.error
                    : AppColors.primary,
                foregroundColor: Colors.white,
                icon: AnimatedSwitcher(
                  duration: AppConstants.animationFast,
                  child: Icon(
                    movieDetailState.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey(movieDetailState.isFavorite),
                  ),
                ),
                label: Text(
                  movieDetailState.isFavorite ? 'Remove' : 'Add to List',
                  style: AppTypography.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: _expandedHeight,
          pinned: true,
          backgroundColor: AppColors.surface,
          flexibleSpace: FlexibleSpaceBar(
            background: ShimmerWidget(
              width: double.infinity,
              height: _expandedHeight,
              borderRadius: 0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // content below placeholder header
                ShimmerWidget(
                  width: 250,
                  height: 32,
                  borderRadius: AppConstants.radiusSmall,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                ShimmerWidget(
                  width: double.infinity,
                  height: 120,
                  borderRadius: AppConstants.radiusMedium,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                    child: ShimmerWidget(
                      width: double.infinity,
                      height: 20,
                      borderRadius: AppConstants.radiusSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ErrorDisplay(message: error),
          const SizedBox(height: AppConstants.paddingLarge),
          ElevatedButton.icon(
            onPressed: _loadMovieDetails,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieDetails(MovieDetailState state, Size screenSize) {
    final movie = state.movie!;
    final appBarOpacity = (_scrollOffset / _expandedHeight).clamp(0.0, 1.0);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: _expandedHeight,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.surface.withValues(alpha: appBarOpacity),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            title: AnimatedOpacity(
              opacity: appBarOpacity,
              duration: AppConstants.animationFast,
              child: Text(
                movie.title,
                style: AppTypography.textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.heroTag ?? 'movie_${movie.imdbID}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: movie.poster,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ShimmerWidget(
                        width: double.infinity,
                        height: _expandedHeight,
                        borderRadius: 0,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surfaceContainer,
                        child: const Center(
                          child: Icon(
                            Icons.movie_outlined,
                            size: 64,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      left: AppConstants.paddingLarge,
                      right: AppConstants.paddingLarge,
                      bottom: AppConstants.paddingLarge,
                      child: AnimationConfiguration.staggeredList(
                        position: 0,
                        duration: AppConstants.animationMedium,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: AppTypography.textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0, 2),
                                        blurRadius: 8,
                                        color: Colors.black.withValues(alpha: 0.7),
                                      ),
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppConstants.paddingSmall),
                                Row(
                                  children: [
                                    _buildHeaderChip(movie.year),
                                    const SizedBox(width: AppConstants.paddingSmall),
                                    _buildHeaderChip(movie.type.toUpperCase()),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [AppColors.glowPrimary],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'WATCH NOW',
                                            style: AppTypography.caption.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimationLimiter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMovieInfo(movie),
                    const SizedBox(height: AppConstants.paddingLarge),
                    _buildPlotSection(movie),
                    const SizedBox(height: AppConstants.paddingLarge),
                    _buildDetailsSection(movie),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMovieInfo(movie) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              boxShadow: const [AppColors.shadowMedium],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('Year', movie.year),
                    _buildDivider(),
                    _buildStatItem('Type', movie.type.toUpperCase()),
                    _buildDivider(),
                    _buildStatItem('Rating', 'N/A'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.divider,
    );
  }

  Widget _buildPlotSection(movie) {
    // Since the existing movie model might not have plot, we'll show a placeholder
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: AppTypography.sectionHeader.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: const [AppColors.shadowMedium],
                ),
                child: Text(
                  'Detailed plot information would be displayed here when available from the API. This movie appears to be a ${movie.type} from ${movie.year}.',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(movie) {
    return AnimationConfiguration.staggeredList(
      position: 3,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Details',
                style: AppTypography.sectionHeader.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: const [AppColors.shadowMedium],
                ),
                child: Column(
                  children: [
                    _buildDetailRow('IMDb ID', movie.imdbID),
                    _buildDetailDivider(),
                    _buildDetailRow('Title', movie.title),
                    _buildDetailDivider(),
                    _buildDetailRow('Year', movie.year),
                    _buildDetailDivider(),
                    _buildDetailRow('Type', movie.type.toUpperCase()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTypography.textTheme.labelMedium?.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Text(
              value,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Divider(
        color: AppColors.divider,
        thickness: 0.5,
      ),
    );
  }

  void _toggleFavorite() {
    ref.read(movieDetailProvider.notifier).toggleFavorite();
  }
}