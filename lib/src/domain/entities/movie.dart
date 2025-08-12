import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String imdbID;
  final String title;
  final String year;
  final String type;
  final String poster;

  const Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.type,
    required this.poster,
  });

  @override
  List<Object?> get props => [imdbID, title, year, type, poster];
}
