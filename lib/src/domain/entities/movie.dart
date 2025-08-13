import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final String source;
  final String value;

  const Rating({required this.source, required this.value});

  @override
  List<Object?> get props => [source, value];
}

class Movie extends Equatable {
  final String imdbID;
  final String title;
  final String year;
  final String type;
  final String poster;

  // OMDb detail fields (nullable when using search endpoint)
  final String? rated;
  final String? released;
  final String? runtime;
  final String? genre; // comma separated
  final String? director;
  final String? writer;
  final String? actors;
  final String? plot;
  final String? language;
  final String? country;
  final String? awards;
  final List<Rating>? ratings;
  final String? metascore;
  final String? imdbRating; // string per OMDb
  final String? imdbVotes;
  final String? dvd;
  final String? boxOffice;
  final String? production;
  final String? website;

  const Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.type,
    required this.poster,
    this.rated,
    this.released,
    this.runtime,
    this.genre,
    this.director,
    this.writer,
    this.actors,
    this.plot,
    this.language,
    this.country,
    this.awards,
    this.ratings,
    this.metascore,
    this.imdbRating,
    this.imdbVotes,
    this.dvd,
    this.boxOffice,
    this.production,
    this.website,
  });

  @override
  List<Object?> get props => [
    imdbID,
    title,
    year,
    type,
    poster,
    rated,
    released,
    runtime,
    genre,
    director,
    writer,
    actors,
    plot,
    language,
    country,
    awards,
    ratings,
    metascore,
    imdbRating,
    imdbVotes,
    dvd,
    boxOffice,
    production,
    website,
  ];
}
