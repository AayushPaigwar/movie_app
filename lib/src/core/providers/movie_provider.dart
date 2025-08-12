import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_stream_app/src/domain/usecases/add_favorite_movie.dart';
import 'package:movie_stream_app/src/domain/usecases/get_favorite_movies.dart';
import 'package:movie_stream_app/src/domain/usecases/get_movie_detail.dart';
import 'package:movie_stream_app/src/domain/usecases/is_favorite_movie.dart';
import 'package:movie_stream_app/src/domain/usecases/remove_favorite_movie.dart';
import 'package:movie_stream_app/src/domain/usecases/search_movies.dart';

import '../../domain/entities/movie.dart';
import 'providers.dart';

class MovieSearchState extends Equatable {
  final List<Movie> movies;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasReachedMax;
  final int currentPage;
  final String query;

  const MovieSearchState({
    this.movies = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.query = '',
  });

  MovieSearchState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasReachedMax,
    int? currentPage,
    String? query,
  }) {
    return MovieSearchState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      query: query ?? this.query,
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
  ];
}

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
      error: error ?? this.error,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [movie, isLoading, error, isFavorite];
}

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
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [movies, isLoading, error];
}

class MovieSearchNotifier extends StateNotifier<MovieSearchState> {
  MovieSearchNotifier(this._searchMovies) : super(const MovieSearchState());

  final SearchMovies _searchMovies;

  Future<void> searchMovies(String query, {bool loadMore = false}) async {
    if (query.isEmpty) return;

    if (loadMore) {
      if (state.isLoadingMore || state.hasReachedMax) return;
      state = state.copyWith(isLoadingMore: true);
    } else {
      state = state.copyWith(
        isLoading: true,
        error: null,
        movies: [],
        currentPage: 1,
        hasReachedMax: false,
        query: query,
      );
    }

    try {
      final movies = await _searchMovies(
        query,
        page: loadMore ? state.currentPage + 1 : 1,
      );

      final newMovies = loadMore ? [...state.movies, ...movies] : movies;
      state = state.copyWith(
        movies: newMovies,
        isLoading: false,
        isLoadingMore: false,
        hasReachedMax: movies.length < 10,
        currentPage: loadMore ? state.currentPage + 1 : 1,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  void clearSearch() {
    state = const MovieSearchState();
  }
}

class MovieDetailNotifier extends StateNotifier<MovieDetailState> {
  MovieDetailNotifier(
    this._getMovieDetail,
    this._isFavoriteMovie,
    this._addFavoriteMovie,
    this._removeFavoriteMovie,
  ) : super(const MovieDetailState());

  final GetMovieDetail _getMovieDetail;
  final IsFavoriteMovie _isFavoriteMovie;
  final AddFavoriteMovie _addFavoriteMovie;
  final RemoveFavoriteMovie _removeFavoriteMovie;

  Future<void> loadMovieDetail(String imdbId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final movie = await _getMovieDetail(imdbId);
      final isFavorite = await _isFavoriteMovie(imdbId);

      state = state.copyWith(
        movie: movie,
        isLoading: false,
        error: null,
        isFavorite: isFavorite,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleFavorite() async {
    if (state.movie == null) return;

    final movie = state.movie!;
    final wasFavorite = state.isFavorite;

    state = state.copyWith(isFavorite: !wasFavorite);

    try {
      if (wasFavorite) {
        await _removeFavoriteMovie(movie as String);
      } else {
        await _addFavoriteMovie(movie);
      }
    } catch (e) {
      state = state.copyWith(isFavorite: wasFavorite);
    }
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier(this._getFavoriteMovies) : super(const FavoritesState());

  final GetFavoriteMovies _getFavoriteMovies;

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final movies = await _getFavoriteMovies();
      state = state.copyWith(movies: movies, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void removeFavorite(String imdbId) {
    final updatedMovies = state.movies
        .where((m) => m.imdbID != imdbId)
        .toList();
    state = state.copyWith(movies: updatedMovies);
  }
}

final movieSearchProvider =
    StateNotifierProvider<MovieSearchNotifier, MovieSearchState>((ref) {
      return MovieSearchNotifier(ref.read(searchMoviesUseCaseProvider));
    });

final movieDetailProvider =
    StateNotifierProvider<MovieDetailNotifier, MovieDetailState>((ref) {
      return MovieDetailNotifier(
        ref.read(getMovieDetailUseCaseProvider),
        ref.read(isFavoriteMovieUseCaseProvider),
        ref.read(addFavoriteMovieUseCaseProvider),
        ref.read(removeFavoriteMovieUseCaseProvider),
      );
    });

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
      return FavoritesNotifier(ref.read(getFavoriteMoviesUseCaseProvider));
    });

final currentGenreProvider = StateProvider<String>((ref) => 'All');
