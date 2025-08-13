import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
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

  @override
  List<Object?> get props => [selectedType, selectedYear, selectedGenre, query];
}
