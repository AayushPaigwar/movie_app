import 'package:equatable/equatable.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();
  @override
  List<Object?> get props => [];
}

class FilterTypeUpdated extends FilterEvent {
  final String? type;
  const FilterTypeUpdated(this.type);
  @override
  List<Object?> get props => [type];
}

class FilterYearUpdated extends FilterEvent {
  final String? year;
  const FilterYearUpdated(this.year);
  @override
  List<Object?> get props => [year];
}

class FilterGenreUpdated extends FilterEvent {
  final String? genre;
  const FilterGenreUpdated(this.genre);
  @override
  List<Object?> get props => [genre];
}

class FilterQueryUpdated extends FilterEvent {
  final String query;
  const FilterQueryUpdated(this.query);
  @override
  List<Object?> get props => [query];
}

class FilterReset extends FilterEvent {
  const FilterReset();
}
