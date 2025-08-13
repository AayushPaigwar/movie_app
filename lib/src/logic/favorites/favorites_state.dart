import 'package:equatable/equatable.dart';
import 'package:movie_stream_app/src/domain/entities/movie.dart';

class FavoritesState extends Equatable {
  final List<Movie> movies;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.movies = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [movies, isLoading, error];
}
