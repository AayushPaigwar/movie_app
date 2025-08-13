import 'package:equatable/equatable.dart';
import 'package:movie_stream_app/src/domain/entities/movie.dart';

class MovieSearchState extends Equatable {
  final List<Movie> movies;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasReachedMax;
  final int currentPage;
  final String query;
  final String? type;
  final String? year;

  const MovieSearchState({
    this.movies = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.query = '',
    this.type,
    this.year,
  });

  MovieSearchState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasReachedMax,
    int? currentPage,
    String? query,
    String? type,
    String? year,
  }) {
    return MovieSearchState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      query: query ?? this.query,
      type: type ?? this.type,
      year: year ?? this.year,
    );
  }

  @override
  List<Object?> get props => [
    movies,
    isLoading,
    isLoadingMore,
    error,
    hasReachedMax,
    currentPage,
    query,
    type,
    year,
  ];
}
