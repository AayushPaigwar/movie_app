import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_stream_app/src/core/constants/app_constants.dart';
import 'package:movie_stream_app/src/core/theme/app_colors.dart';
import 'package:movie_stream_app/src/core/theme/app_typography.dart';
import 'package:movie_stream_app/src/logic/movie_detail/movie_detail_bloc.dart';
import 'package:movie_stream_app/src/logic/movie_detail/movie_detail_event.dart';
import 'package:movie_stream_app/src/logic/movie_detail/movie_detail_state.dart';

// Keep Bloc state management but upgrade UI to Slivers similar to Riverpod version.

class EnhancedMovieDetailScreen extends StatefulWidget {
  final String imdbID;
  final String? heroTag;

  const EnhancedMovieDetailScreen({
    super.key,
    required this.imdbID,
    this.heroTag,
  });

  @override
  State<EnhancedMovieDetailScreen> createState() =>
      _EnhancedMovieDetailScreenState();
}

class _EnhancedMovieDetailScreenState extends State<EnhancedMovieDetailScreen> {
  static const double _expandedHeight = 350.0;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailBloc>().add(MovieDetailRequested(widget.imdbID));
    });
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradientPrimary,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
            builder: (context, state) {
              if (state.isLoading) {
                // Skeleton shimmer for detail screen (poster + sections)
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: _expandedHeight,
                      pinned: true,
                      backgroundColor: AppColors.surface,
                      flexibleSpace: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceContainer,
                        ),
                        child: Container(color: AppColors.surfaceContainer),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _ShimmerBlock(height: 28, width: 220),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              // placeholders converted to const after making widgets const-compatible
                            ],
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              _ShimmerChip(width: 60),
                              _ShimmerChip(width: 80),
                              _ShimmerChip(width: 50),
                              _ShimmerChip(width: 70),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _ShimmerCard(lines: 4),
                          const SizedBox(height: 24),
                          _ShimmerCard(lines: 6),
                        ]),
                      ),
                    ),
                  ],
                );
              }

              if (state.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Failed to load details',
                          style: AppTypography.textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        Text(
                          state.error!,
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppConstants.paddingLarge),
                        ElevatedButton.icon(
                          onPressed: () => context.read<MovieDetailBloc>().add(
                            MovieDetailRequested(widget.imdbID),
                          ),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final movie = state.movie;
              if (movie == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.movie_outlined,
                          size: 48,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        Text(
                          'No details available',
                          style: AppTypography.textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          'Try again to fetch the movie details.',
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppConstants.paddingLarge),
                        ElevatedButton.icon(
                          onPressed: () => context.read<MovieDetailBloc>().add(
                            MovieDetailRequested(widget.imdbID),
                          ),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return _buildSliverDetail(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSliverDetail(MovieDetailState state) {
    final movie = state.movie!;
    final opacity = (_scrollOffset / _expandedHeight).clamp(0.0, 1.0);

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: _expandedHeight,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.surface.withOpacity(
                opacity * 0.9 + 0.05,
              ),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: Opacity(
                opacity: opacity,
                child: Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.heroTag ?? 'detail_${movie.imdbID}',
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        movie.poster,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surfaceContainer,
                          child: const Icon(
                            Icons.broken_image,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.85),
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: AppConstants.paddingLarge,
                        right: AppConstants.paddingLarge,
                        bottom: AppConstants.paddingLarge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: AppTypography.textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 12,
                                        color: Colors.black54,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _InfoChip(label: movie.year),
                                _InfoChip(label: movie.type.toUpperCase()),
                                if ((movie.rated ?? '').isNotEmpty)
                                  _InfoChip(label: movie.rated!),
                                if ((movie.runtime ?? '').isNotEmpty)
                                  _InfoChip(label: movie.runtime!),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => context.read<MovieDetailBloc>().add(
                    const MovieDetailToggleFavorite(),
                  ),
                  icon: Icon(
                    state.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: state.isFavorite
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            // Body content
            SliverPadding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if ((movie.genre ?? '').isNotEmpty)
                    _SectionCard(
                      title: 'Genres',
                      child: Text(
                        movie.genre!,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  if ((movie.plot ?? '').isNotEmpty)
                    _SectionCard(
                      title: 'Overview',
                      child: Text(
                        movie.plot!,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  if ((movie.imdbRating ?? '').isNotEmpty ||
                      (movie.metascore ?? '').isNotEmpty ||
                      (movie.ratings?.isNotEmpty ?? false))
                    _SectionCard(
                      title: 'Ratings',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((movie.imdbRating ?? '').isNotEmpty)
                            _DetailRow(
                              label: 'IMDb',
                              value:
                                  '${movie.imdbRating} (${movie.imdbVotes ?? '-'})',
                            ),
                          if ((movie.metascore ?? '').isNotEmpty)
                            _DetailRow(
                              label: 'Metascore',
                              value: movie.metascore!,
                            ),
                          if (movie.ratings != null)
                            ...movie.ratings!.map(
                              (r) =>
                                  _DetailRow(label: r.source, value: r.value),
                            ),
                        ],
                      ),
                    ),
                  _SectionCard(
                    title: 'Details',
                    child: Column(
                      children: [
                        _DetailRow(label: 'Title', value: movie.title),
                        _DetailRow(label: 'Year', value: movie.year),
                        _DetailRow(
                          label: 'Type',
                          value: movie.type.toUpperCase(),
                        ),
                        if ((movie.released ?? '').isNotEmpty)
                          _DetailRow(label: 'Released', value: movie.released!),
                        if ((movie.runtime ?? '').isNotEmpty)
                          _DetailRow(label: 'Runtime', value: movie.runtime!),
                        if ((movie.director ?? '').isNotEmpty)
                          _DetailRow(label: 'Director', value: movie.director!),
                        if ((movie.writer ?? '').isNotEmpty)
                          _DetailRow(label: 'Writer', value: movie.writer!),
                        if ((movie.actors ?? '').isNotEmpty)
                          _DetailRow(label: 'Actors', value: movie.actors!),
                        if ((movie.language ?? '').isNotEmpty)
                          _DetailRow(label: 'Language', value: movie.language!),
                        if ((movie.country ?? '').isNotEmpty)
                          _DetailRow(label: 'Country', value: movie.country!),
                        if ((movie.awards ?? '').isNotEmpty)
                          _DetailRow(label: 'Awards', value: movie.awards!),
                        if ((movie.boxOffice ?? '').isNotEmpty)
                          _DetailRow(
                            label: 'Box Office',
                            value: movie.boxOffice!,
                          ),
                        if ((movie.production ?? '').isNotEmpty)
                          _DetailRow(
                            label: 'Production',
                            value: movie.production!,
                          ),
                        if ((movie.website ?? '').isNotEmpty)
                          _DetailRow(label: 'Website', value: movie.website!),
                        _DetailRow(label: 'IMDb ID', value: movie.imdbID),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ]),
              ),
            ),
          ],
        ),
        // Floating favorite button
        Positioned(
          right: 16,
          bottom: 24,
          child: FloatingActionButton.extended(
            onPressed: () => context.read<MovieDetailBloc>().add(
              const MovieDetailToggleFavorite(),
            ),
            backgroundColor: state.isFavorite
                ? AppColors.primary
                : AppColors.surface,
            foregroundColor: state.isFavorite
                ? Colors.white
                : AppColors.textPrimary,
            icon: Icon(state.isFavorite ? Icons.check : Icons.add),
            label: Text(state.isFavorite ? 'In Watchlist' : 'Add to Watchlist'),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Text(
        label,
        style: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingLarge),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            child,
          ],
        ),
      ),
    );
  }
}

// Shimmer placeholders (lightweight, avoid external dependencies here)
class _ShimmerBlock extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  const _ShimmerBlock({
    required this.height,
    required this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedShimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class _ShimmerChip extends StatelessWidget {
  final double width;
  const _ShimmerChip({required this.width});

  @override
  Widget build(BuildContext context) {
    return _ShimmerBlock(height: 20, width: width, borderRadius: 16);
  }
}

class _ShimmerCard extends StatelessWidget {
  final int lines;
  const _ShimmerCard({this.lines = 4});

  @override
  Widget build(BuildContext context) {
    return _AnimatedShimmer(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(lines, (i) {
            final w = (i == lines - 1) ? 140.0 : double.infinity;
            return Padding(
              padding: EdgeInsets.only(
                bottom: i == lines - 1 ? 0 : AppConstants.paddingSmall,
              ),
              child: _ShimmerBlock(height: 16, width: w),
            );
          }),
        ),
      ),
    );
  }
}

class _AnimatedShimmer extends StatefulWidget {
  final Widget child;
  const _AnimatedShimmer({required this.child});

  @override
  State<_AnimatedShimmer> createState() => _AnimatedShimmerState();
}

class _AnimatedShimmerState extends State<_AnimatedShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            final gradient = LinearGradient(
              begin: Alignment(-1 - 0.3 + _controller.value * 2, 0),
              end: const Alignment(1.0, 0.0),
              colors: [
                AppColors.surfaceContainer.withOpacity(0.3),
                AppColors.surfaceContainer.withOpacity(0.7),
                AppColors.surfaceContainer.withOpacity(0.3),
              ],
              stops: const [0.2, 0.5, 0.8],
            );
            return gradient.createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
