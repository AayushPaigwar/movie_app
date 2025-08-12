import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'shimmer_widget.dart';

class EnhancedMovieCard extends StatelessWidget {
  final String title;
  final String posterUrl;
  final String? year;
  final String? genre;
  final double? rating;
  final VoidCallback onTap;
  final int index;
  final bool isHero;
  final String? heroTag;

  const EnhancedMovieCard({
    super.key,
    required this.title,
    required this.posterUrl,
    this.year,
    this.genre,
    this.rating,
    required this.onTap,
    this.index = 0,
    this.isHero = false,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            width: AppConstants.movieCardWidth,
            margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPosterImage(),
                    const SizedBox(height: AppConstants.paddingSmall),
                    _buildMovieInfo(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    Widget imageWidget = Container(
      width: AppConstants.movieCardWidth,
      height: AppConstants.movieCardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: const [AppColors.shadowMedium],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        child: CachedNetworkImage(
          imageUrl: posterUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => ShimmerWidget(
            width: AppConstants.movieCardWidth,
            height: AppConstants.movieCardHeight,
            borderRadius: AppConstants.radiusLarge,
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
            child: const Center(
              child: Icon(
                Icons.movie_outlined,
                size: 48,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          fadeInDuration: AppConstants.animationFast,
          fadeOutDuration: AppConstants.animationFast,
        ),
      ),
    );

    if (isHero && heroTag != null) {
      return Hero(tag: heroTag!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildMovieInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,

            style: AppTypography.movieTitle.copyWith(
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (year != null || genre != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                if (year != null) ...[
                  Text(
                    year!,
                    style: AppTypography.movieSubtitle.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (genre != null) ...[
                    Text(
                      ' • ',
                      style: AppTypography.movieSubtitle.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        genre!,
                        style: AppTypography.movieSubtitle.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ] else if (genre != null)
                  Expanded(
                    child: Text(
                      genre!,
                      style: AppTypography.movieSubtitle.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
          if (rating != null && rating! > 0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  rating!.toStringAsFixed(1),
                  style: AppTypography.rating.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class EnhancedCarouselCard extends StatelessWidget {
  final String title;
  final String posterUrl;
  final String? description;
  final VoidCallback onTap;
  final int index;

  const EnhancedCarouselCard({
    super.key,
    required this.title,
    required this.posterUrl,
    this.description,
    required this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        horizontalOffset: 100.0,
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppConstants.radiusExtraLarge,
                ),
                boxShadow: const [AppColors.shadowLarge],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppConstants.radiusExtraLarge,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CarouselShimmer(),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusExtraLarge,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.movie_outlined,
                            size: 64,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      fadeInDuration: AppConstants.animationFast,
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
                          stops: const [0.3, 0.7, 1.0],
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
                            title,
                            style: AppTypography.textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (description != null) ...[
                            const SizedBox(height: AppConstants.paddingSmall),
                            Text(
                              description!,
                              style: AppTypography.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
