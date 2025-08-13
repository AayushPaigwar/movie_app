import 'package:movie_stream_app/src/domain/repositories/movie_repository.dart';

class IsFavoriteMovie {
  final MovieRepository repository;

  IsFavoriteMovie(this.repository);

  Future<bool> call(String imdbID) async {
    return await repository.isFavoriteMovie(imdbID);
  }
}
