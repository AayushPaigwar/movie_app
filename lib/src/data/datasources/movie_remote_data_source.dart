import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_stream_app/src/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  // Search movies
  Future<List<MovieModel>> searchMovies(
    String query, {
    String? type,
    String? year,
    int page = 1,
  });
  Future<MovieModel> getMovieDetail(String id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  final String? _apiKey = dotenv.env['OMDB_API_KEY'];
  final String? _baseUrl = dotenv.env['OMDB_BASE_URL'];

  @override
  // Search movies
  Future<List<MovieModel>> searchMovies(
    String query, {
    String? type,
    String? year,
    int page = 1,
  }) async {
    var url = '$_baseUrl?s=$query&apikey=$_apiKey&page=$page';
    if (type != null) {
      url += '&type=$type';
    }
    if (year != null) {
      url += '&y=$year';
    }

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['Response'] == 'True') {
        return (result['Search'] as List)
            .map((e) => MovieModel.fromJson(e))
            .toList();
      } else {
        throw Exception(result['Error']);
      }
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  // Get movie detail
  Future<MovieModel> getMovieDetail(String id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl?i=$id&apikey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie detail');
    }
  }
}
