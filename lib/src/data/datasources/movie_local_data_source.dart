import 'dart:convert';

import 'package:movie_stream_app/src/data/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MovieLocalDataSource {
  Future<void> addFavoriteMovie(MovieModel movie);
  Future<void> removeFavoriteMovie(String imdbID);
  Future<List<MovieModel>> getFavoriteMovies();
  Future<bool> isFavoriteMovie(String imdbID);
}

//Favorite movies
class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  static const String _favoritesKey = 'favoriteMovies';

  @override
  //add favorite movie
  Future<void> addFavoriteMovie(MovieModel movie) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMovies = await getFavoriteMovies();
    favoriteMovies.add(movie);
    await _saveFavoriteMovies(prefs, favoriteMovies);
  }

  @override
  //remove favorite movie
  Future<void> removeFavoriteMovie(String imdbID) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMovies = await getFavoriteMovies();
    favoriteMovies.removeWhere((movie) => movie.imdbID == imdbID);
    await _saveFavoriteMovies(prefs, favoriteMovies);
  }

  @override
  //get favorite movies
  Future<List<MovieModel>> getFavoriteMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = prefs.getStringList(_favoritesKey) ?? [];
    return jsonStringList
        .map((jsonString) => MovieModel.fromJson(json.decode(jsonString)))
        .toList();
  }

  @override
  //check if movie is favorite
  Future<bool> isFavoriteMovie(String imdbID) async {
    final favoriteMovies = await getFavoriteMovies();
    return favoriteMovies.any((movie) => movie.imdbID == imdbID);
  }

  // Save favorite movies
  Future<void> _saveFavoriteMovies(
    SharedPreferences prefs,
    List<MovieModel> movies,
  ) async {
    final jsonStringList = movies
        .map((movie) => json.encode(movie.toJson()))
        .toList();
    await prefs.setStringList(_favoritesKey, jsonStringList);
  }
}
