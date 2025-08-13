import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_stream_app/src/domain/usecases/add_favorite_movie.dart';
import 'package:movie_stream_app/src/domain/usecases/get_movie_detail.dart';
import 'package:movie_stream_app/src/domain/usecases/is_favorite_movie.dart';
import 'package:movie_stream_app/src/domain/usecases/remove_favorite_movie.dart';

import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc(
    this._getMovieDetail,
    this._isFavoriteMovie,
    this._addFavoriteMovie,
    this._removeFavoriteMovie,
  ) : super(const MovieDetailState()) {
    on<MovieDetailRequested>(_onRequested);
    on<MovieDetailToggleFavorite>(_onToggleFavorite);
  }

  final GetMovieDetail _getMovieDetail;
  final IsFavoriteMovie _isFavoriteMovie;
  final AddFavoriteMovie _addFavoriteMovie;
  final RemoveFavoriteMovie _removeFavoriteMovie;

  Future<void> _onRequested(
    MovieDetailRequested event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final movie = await _getMovieDetail(event.imdbId);
      final isFav = await _isFavoriteMovie(event.imdbId);
      emit(
        state.copyWith(
          movie: movie,
          isFavorite: isFav,
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    MovieDetailToggleFavorite event,
    Emitter<MovieDetailState> emit,
  ) async {
    final movie = state.movie;
    if (movie == null) return;

    final wasFav = state.isFavorite;
    emit(state.copyWith(isFavorite: !wasFav));
    try {
      if (wasFav) {
        await _removeFavoriteMovie(movie.imdbID);
      } else {
        await _addFavoriteMovie(movie);
      }
    } catch (_) {
      emit(state.copyWith(isFavorite: wasFav));
    }
  }
}
