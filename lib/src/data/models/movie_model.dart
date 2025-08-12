import 'package:movie_stream_app/src/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.imdbID,
    required super.title,
    required super.year,
    required super.type,
    required super.poster,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      imdbID: json['imdbID'],
      title: json['Title'],
      year: json['Year'],
      type: json['Type'],
      poster: json['Poster'] == 'N/A'
          ? 'https://via.placeholder.com/300'
          : json['Poster'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbID,
      'Title': title,
      'Year': year,
      'Type': type,
      'Poster': poster,
    };
  }
}
