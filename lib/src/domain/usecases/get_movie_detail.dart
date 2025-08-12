import 'package:movie_stream_app/src/domain/entities/movie.dart';
import 'package:movie_stream_app/src/domain/repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Movie> call(String id) async {
    return await repository.getMovieDetail(id);
  }
}
