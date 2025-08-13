import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_stream_app/src/domain/usecases/get_favorite_movies.dart';
import 'package:movie_stream_app/src/domain/usecases/remove_favorite_movie.dart';

import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this._getFavoriteMovies, this._removeFavoriteMovie)
    : super(const FavoritesState()) {
    on<FavoritesRequested>(_onRequested);
    on<FavoriteRemoved>(_onRemoved);
  }

  final GetFavoriteMovies _getFavoriteMovies;
  final RemoveFavoriteMovie _removeFavoriteMovie;

  Future<void> _onRequested(
    FavoritesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final movies = await _getFavoriteMovies();
      emit(state.copyWith(movies: movies, isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onRemoved(
    FavoriteRemoved event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _removeFavoriteMovie(event.imdbId);
      final updated = state.movies
          .where((m) => m.imdbID != event.imdbId)
          .toList();
      emit(state.copyWith(movies: updated));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
