import 'package:equatable/equatable.dart';
import 'package:movie_stream_app/src/domain/entities/movie.dart';

class MovieDetailState extends Equatable {
  final Movie? movie;
  final bool isLoading;
  final String? error;
  final bool isFavorite;

  const MovieDetailState({
    this.movie,
    this.isLoading = false,
    this.error,
    this.isFavorite = false,
  });

  MovieDetailState copyWith({
    Movie? movie,
    bool? isLoading,
    String? error,
    bool? isFavorite,
  }) {
    return MovieDetailState(
      movie: movie ?? this.movie,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [movie, isLoading, error, isFavorite];
}
