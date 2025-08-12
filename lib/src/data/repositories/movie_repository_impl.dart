import 'package:movie_stream_app/src/data/datasources/movie_local_data_source.dart';
import 'package:movie_stream_app/src/data/datasources/movie_remote_data_source.dart';
import 'package:movie_stream_app/src/data/models/movie_model.dart';
import 'package:movie_stream_app/src/domain/entities/movie.dart';
import 'package:movie_stream_app/src/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<List<Movie>> searchMovies(String query, {String? type, String? year, int page = 1}) async {
    return await remoteDataSource.searchMovies(query, type: type, year: year, page: page);
  }

  @override
  Future<Movie> getMovieDetail(String id) async {
    return await remoteDataSource.getMovieDetail(id);
  }

  @override
  Future<void> addFavoriteMovie(Movie movie) async {
    await localDataSource.addFavoriteMovie(movie as MovieModel);
  }

  @override
  Future<void> removeFavoriteMovie(String imdbID) async {
    await localDataSource.removeFavoriteMovie(imdbID);
  }

  @override
  Future<List<Movie>> getFavoriteMovies() async {
    return await localDataSource.getFavoriteMovies();
  }

  @override
  Future<bool> isFavoriteMovie(String imdbID) async {
    return await localDataSource.isFavoriteMovie(imdbID);
  }
}
