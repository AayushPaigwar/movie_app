import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_stream_app/src/domain/usecases/search_movies.dart';

import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  MovieSearchBloc(this._searchMovies) : super(const MovieSearchState()) {
    on<MovieSearchRequested>(_onSearchRequested);
    on<MovieSearchLoadMore>(_onLoadMore);
  }

  final SearchMovies _searchMovies;

  Future<void> _onSearchRequested(
    MovieSearchRequested event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const MovieSearchState());
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        movies: [],
        currentPage: 1,
        hasReachedMax: false,
        query: query,
        type: event.type,
        year: event.year,
        error: null,
      ),
    );

    try {
      final movies = await _searchMovies(
        query,
        type: event.type,
        year: event.year,
        page: 1,
      );
      emit(
        state.copyWith(
          movies: movies,
          isLoading: false,
          hasReachedMax: movies.length < 10,
          currentPage: 1,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    MovieSearchLoadMore event,
    Emitter<MovieSearchState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax || state.query.isEmpty) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final movies = await _searchMovies(
        state.query,
        type: state.type,
        year: state.year,
        page: nextPage,
      );
      final newMovies = [...state.movies, ...movies];
      emit(
        state.copyWith(
          movies: newMovies,
          isLoadingMore: false,
          hasReachedMax: movies.length < 10,
          currentPage: nextPage,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }
}
