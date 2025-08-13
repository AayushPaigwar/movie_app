import 'package:movie_stream_app/src/domain/entities/movie.dart';
import 'package:movie_stream_app/src/domain/repositories/movie_repository.dart';

class AddFavoriteMovie {
  final MovieRepository repository;

  AddFavoriteMovie(this.repository);

  Future<void> call(Movie movie) async {
    await repository.addFavoriteMovie(movie);
  }
}
