import 'package:movie_stream_app/src/domain/entities/movie.dart';
import 'package:movie_stream_app/src/domain/repositories/movie_repository.dart';

class GetFavoriteMovies {
  final MovieRepository repository;

  GetFavoriteMovies(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getFavoriteMovies();
  }
}
