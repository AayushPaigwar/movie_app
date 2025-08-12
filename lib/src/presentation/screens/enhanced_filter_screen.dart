import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/providers/movie_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

// Filter state provider
final filterStateProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

class FilterState {
  final String? selectedType;
  final String? selectedYear;
  final String? selectedGenre;
  final String query;

  const FilterState({
    this.selectedType,
    this.selectedYear,
    this.selectedGenre,
    this.query = '',
  });

  FilterState copyWith({
    String? selectedType,
    String? selectedYear,
    String? selectedGenre,
    String? query,
  }) {
    return FilterState(
      selectedType: selectedType ?? this.selectedType,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      query: query ?? this.query,
    );
  }
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void updateType(String? type) {
    state = state.copyWith(selectedType: type);
  }

  void updateYear(String? year) {
    state = state.copyWith(selectedYear: year);
  }

  void updateGenre(String? genre) {
    state = state.copyWith(selectedGenre: genre);
  }

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void reset() {
    state = const FilterState();
  }
}

class EnhancedFilterScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const EnhancedFilterScreen({
    super.key,
    this.initialQuery,
  });

  @override
  ConsumerState<EnhancedFilterScreen> createState() => _EnhancedFilterScreenState();
}

class _EnhancedFilterScreenState extends ConsumerState<EnhancedFilterScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    if (widget.initialQuery != null) {
      _queryController.text = widget.initialQuery!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(filterStateProvider.notifier).updateQuery(widget.initialQuery!);
      });
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationMedium,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterStateProvider);

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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: AnimationLimiter(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppConstants.paddingLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSearchSection(filterState),
                            const SizedBox(height: AppConstants.paddingLarge),
                            _buildTypeSection(filterState),
                            const SizedBox(height: AppConstants.paddingLarge),
                            _buildYearSection(filterState),
                            const SizedBox(height: AppConstants.paddingLarge),
                            _buildGenreSection(filterState),
                            const SizedBox(height: AppConstants.paddingExtraLarge),
                            _buildActionButtons(filterState),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: -50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter & Search',
                        style: AppTypography.textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Refine your movie discovery',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _resetFilters,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(FilterState state) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: _buildSection(
            'Search Query',
            'What are you looking for?',
            TextField(
              controller: _queryController,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Enter movie, series, or episode name...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                ),
                suffixIcon: _queryController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _queryController.clear();
                          ref.read(filterStateProvider.notifier).updateQuery('');
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.onSurfaceVariant,
                        ),
                      )
                    : null,
              ),
              onChanged: (value) {
                ref.read(filterStateProvider.notifier).updateQuery(value);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSection(FilterState state) {
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: _buildSection(
            'Content Type',
            'Filter by content type',
            Wrap(
              spacing: AppConstants.paddingMedium,
              runSpacing: AppConstants.paddingSmall,
              children: AppConstants.movieTypes.map((type) {
                final isSelected = state.selectedType == type;
                return FilterChip(
                  label: Text(
                    type.toUpperCase(),
                    style: AppTypography.chipLabel.copyWith(
                      color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    ref.read(filterStateProvider.notifier).updateType(
                      selected ? type : null,
                    );
                  },
                  backgroundColor: AppColors.surfaceContainer,
                  selectedColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusExtraLarge),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  elevation: 0,
                  pressElevation: 2,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYearSection(FilterState state) {
    return AnimationConfiguration.staggeredList(
      position: 3,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: _buildSection(
            'Release Year',
            'Filter by release year',
            Wrap(
              spacing: AppConstants.paddingMedium,
              runSpacing: AppConstants.paddingSmall,
              children: AppConstants.years.map((year) {
                final isSelected = state.selectedYear == year;
                return FilterChip(
                  label: Text(
                    year,
                    style: AppTypography.chipLabel.copyWith(
                      color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    ref.read(filterStateProvider.notifier).updateYear(
                      selected && year != 'All Years' ? year : null,
                    );
                  },
                  backgroundColor: AppColors.surfaceContainer,
                  selectedColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusExtraLarge),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  elevation: 0,
                  pressElevation: 2,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenreSection(FilterState state) {
    return AnimationConfiguration.staggeredList(
      position: 4,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: _buildSection(
            'Genre',
            'Filter by movie genre',
            Wrap(
              spacing: AppConstants.paddingMedium,
              runSpacing: AppConstants.paddingSmall,
              children: AppConstants.genres.take(12).map((genre) {
                final isSelected = state.selectedGenre == genre;
                return FilterChip(
                  label: Text(
                    genre,
                    style: AppTypography.chipLabel.copyWith(
                      color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    ref.read(filterStateProvider.notifier).updateGenre(
                      selected && genre != 'All' ? genre : null,
                    );
                  },
                  backgroundColor: AppColors.surfaceContainer,
                  selectedColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusExtraLarge),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  elevation: 0,
                  pressElevation: 2,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(FilterState state) {
    final hasFilters = state.selectedType != null || 
                      state.selectedYear != null || 
                      state.selectedGenre != null ||
                      state.query.isNotEmpty;

    return AnimationConfiguration.staggeredList(
      position: 5,
      duration: AppConstants.animationMedium,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: hasFilters ? _applyFilters : null,
                  icon: const Icon(Icons.search),
                  label: const Text('Apply Filters'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                      vertical: AppConstants.paddingLarge,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All Filters'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                      vertical: AppConstants.paddingLarge,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, Widget child) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: const [AppColors.shadowMedium],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          child,
        ],
      ),
    );
  }

  void _applyFilters() {
    final state = ref.read(filterStateProvider);
    final query = state.query.isNotEmpty ? state.query : 'movie';
    
    // Apply search with filters
    ref.read(movieSearchProvider.notifier).searchMovies(query);
    
    // Navigate back with results
    Navigator.of(context).pop({
      'query': query,
      'type': state.selectedType,
      'year': state.selectedYear,
      'genre': state.selectedGenre,
    });
  }

  void _resetFilters() {
    ref.read(filterStateProvider.notifier).reset();
    _queryController.clear();
  }
}