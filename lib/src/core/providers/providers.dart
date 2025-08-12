import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/movie_local_data_source.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/add_favorite_movie.dart';
import '../../domain/usecases/get_favorite_movies.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/is_favorite_movie.dart';
import '../../domain/usecases/remove_favorite_movie.dart';
import '../../domain/usecases/search_movies.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final movieRemoteDataSourceProvider = Provider<MovieRemoteDataSource>((ref) {
  return MovieRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
  );
});

final movieLocalDataSourceProvider = Provider<MovieLocalDataSource>((ref) {
  return MovieLocalDataSourceImpl();
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl(
    remoteDataSource: ref.read(movieRemoteDataSourceProvider),
    localDataSource: ref.read(movieLocalDataSourceProvider),
  );
});

final searchMoviesUseCaseProvider = Provider<SearchMovies>((ref) {
  return SearchMovies(ref.read(movieRepositoryProvider));
});

final getMovieDetailUseCaseProvider = Provider<GetMovieDetail>((ref) {
  return GetMovieDetail(ref.read(movieRepositoryProvider));
});

final addFavoriteMovieUseCaseProvider = Provider<AddFavoriteMovie>((ref) {
  return AddFavoriteMovie(ref.read(movieRepositoryProvider));
});

final removeFavoriteMovieUseCaseProvider = Provider<RemoveFavoriteMovie>((ref) {
  return RemoveFavoriteMovie(ref.read(movieRepositoryProvider));
});

final getFavoriteMoviesUseCaseProvider = Provider<GetFavoriteMovies>((ref) {
  return GetFavoriteMovies(ref.read(movieRepositoryProvider));
});

final isFavoriteMovieUseCaseProvider = Provider<IsFavoriteMovie>((ref) {
  return IsFavoriteMovie(ref.read(movieRepositoryProvider));
});