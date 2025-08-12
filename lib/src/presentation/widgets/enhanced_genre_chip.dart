import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

class EnhancedGenreChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final int index;

  const EnhancedGenreChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: AppConstants.animationFast,
      child: SlideAnimation(
        horizontalOffset: 30.0,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.only(right: AppConstants.paddingSmall),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppConstants.radiusExtraLarge),
                child: AnimatedContainer(
                  duration: AppConstants.animationFast,
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge,
                    vertical: AppConstants.paddingMedium,
                  ),
                  decoration: BoxDecoration(
                    color: selected 
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppConstants.radiusExtraLarge),
                    border: Border.all(
                      color: selected 
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: selected 
                        ? [AppColors.glowPrimary.copyWith(blurRadius: 8, spreadRadius: 0)]
                        : [AppColors.shadowSmall],
                  ),
                  child: Text(
                    label,
                    style: AppTypography.chipLabel.copyWith(
                      color: selected 
                          ? AppColors.primary
                          : AppColors.onSurface,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GenreChipsList extends StatelessWidget {
  final List<String> genres;
  final String selectedGenre;
  final ValueChanged<String> onGenreSelected;

  const GenreChipsList({
    super.key,
    required this.genres,
    required this.selectedGenre,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return EnhancedGenreChip(
            label: genre,
            selected: genre == selectedGenre,
            index: index,
            onTap: () => onGenreSelected(genre),
          );
        },
      ),
    );
  }
}