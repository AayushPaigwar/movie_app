import 'package:flutter/material.dart';
import 'package:movie_stream_app/src/core/constants/app_constants.dart';
import 'package:movie_stream_app/src/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppConstants.radiusMedium,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerColors[0],
        highlightColor: AppColors.shimmerColors[1],
        period: AppConstants.shimmerDuration,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class MovieCardShimmer extends StatelessWidget {
  const MovieCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.movieCardWidth,
      margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(
            width: AppConstants.movieCardWidth,
            height: AppConstants.movieCardHeight,
            borderRadius: AppConstants.radiusLarge,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          ShimmerWidget(
            width: AppConstants.movieCardWidth * 0.8,
            height: 16,
            borderRadius: AppConstants.radiusSmall,
          ),
          const SizedBox(height: 4),
          ShimmerWidget(
            width: AppConstants.movieCardWidth * 0.6,
            height: 12,
            borderRadius: AppConstants.radiusSmall,
          ),
        ],
      ),
    );
  }
}

class CarouselShimmer extends StatelessWidget {
  const CarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.carouselHeight,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: const ShimmerWidget(
              width: double.infinity,
              height: AppConstants.carouselHeight,
              borderRadius: AppConstants.radiusExtraLarge,
            ),
          );
        },
      ),
    );
  }
}

class SearchResultShimmer extends StatelessWidget {
  const SearchResultShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Row(
        children: [
          const ShimmerWidget(
            width: 100,
            height: 140,
            borderRadius: AppConstants.radiusMedium,
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget(
                  width: double.infinity,
                  height: 20,
                  borderRadius: AppConstants.radiusSmall,
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                const ShimmerWidget(
                  width: 150,
                  height: 16,
                  borderRadius: AppConstants.radiusSmall,
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                const ShimmerWidget(
                  width: 100,
                  height: 16,
                  borderRadius: AppConstants.radiusSmall,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Row(
                  children: const [
                    ShimmerWidget(
                      width: 60,
                      height: 24,
                      borderRadius: AppConstants.radiusMedium,
                    ),
                    SizedBox(width: AppConstants.paddingSmall),
                    ShimmerWidget(
                      width: 40,
                      height: 16,
                      borderRadius: AppConstants.radiusSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListShimmer extends StatelessWidget {
  final int itemCount;
  final Widget shimmerItem;

  const ListShimmer({super.key, this.itemCount = 5, required this.shimmerItem});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) => shimmerItem,
    );
  }
}
