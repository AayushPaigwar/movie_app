import 'package:flutter_bloc/flutter_bloc.dart';

import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<FilterTypeUpdated>(
      (e, emit) => emit(state.copyWith(selectedType: e.type)),
    );
    on<FilterYearUpdated>(
      (e, emit) => emit(state.copyWith(selectedYear: e.year)),
    );
    on<FilterGenreUpdated>(
      (e, emit) => emit(state.copyWith(selectedGenre: e.genre)),
    );
    on<FilterQueryUpdated>((e, emit) => emit(state.copyWith(query: e.query)));
    on<FilterReset>((e, emit) => emit(const FilterState()));
  }
}
