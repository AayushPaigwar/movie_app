import 'package:movie_stream_app/src/domain/repositories/movie_repository.dart';

class RemoveFavoriteMovie {
  final MovieRepository repository;

  RemoveFavoriteMovie(this.repository);

  Future<void> call(String imdbID) async {
    await repository.removeFavoriteMovie(imdbID);
  }
}
