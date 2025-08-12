import 'package:movie_stream_app/src/domain/entities/movie.dart';
import 'package:movie_stream_app/src/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<List<Movie>> call(String query, {String? type, String? year, int page = 1}) async {
    return await repository.searchMovies(query, type: type, year: year, page: page);
  }
}
