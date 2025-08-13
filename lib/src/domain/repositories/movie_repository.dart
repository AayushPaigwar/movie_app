import 'package:movie_stream_app/src/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> searchMovies(String query, {String? type, String? year, int page = 1});
  Future<Movie> getMovieDetail(String id);
  Future<void> addFavoriteMovie(Movie movie);
  Future<void> removeFavoriteMovie(String imdbID);
  Future<List<Movie>> getFavoriteMovies();
  Future<bool> isFavoriteMovie(String imdbID);
}
