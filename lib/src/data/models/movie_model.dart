import 'package:movie_stream_app/src/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.imdbID,
    required super.title,
    required super.year,
    required super.type,
    required super.poster,
    super.rated,
    super.released,
    super.runtime,
    super.genre,
    super.director,
    super.writer,
    super.actors,
    super.plot,
    super.language,
    super.country,
    super.awards,
    super.ratings,
    super.metascore,
    super.imdbRating,
    super.imdbVotes,
    super.dvd,
    super.boxOffice,
    super.production,
    super.website,
  });

  static String? _nullableString(dynamic v) {
    if (v == null) return null;
    if (v is String && (v.isEmpty || v == 'N/A')) return null;
    return v.toString();
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      imdbID: json['imdbID'] ?? json['imdbId'] ?? '',
      title: json['Title'] ?? json['title'] ?? '',
      year: json['Year']?.toString() ?? '',
      type: json['Type']?.toString() ?? '',
      poster: (json['Poster'] == null || json['Poster'] == 'N/A')
          ? 'https://via.placeholder.com/300x450?text=No+Image'
          : json['Poster'],
      rated: _nullableString(json['Rated']),
      released: _nullableString(json['Released']),
      runtime: _nullableString(json['Runtime']),
      genre: _nullableString(json['Genre']),
      director: _nullableString(json['Director']),
      writer: _nullableString(json['Writer']),
      actors: _nullableString(json['Actors']),
      plot: _nullableString(json['Plot']),
      language: _nullableString(json['Language']),
      country: _nullableString(json['Country']),
      awards: _nullableString(json['Awards']),
      ratings: (json['Ratings'] is List)
          ? (json['Ratings'] as List)
                .map(
                  (e) => Rating(
                    source: e['Source']?.toString() ?? 'Unknown',
                    value: e['Value']?.toString() ?? '-',
                  ),
                )
                .toList()
          : null,
      metascore: _nullableString(json['Metascore']),
      imdbRating: _nullableString(json['imdbRating']),
      imdbVotes: _nullableString(json['imdbVotes']),
      dvd: _nullableString(json['DVD']),
      boxOffice: _nullableString(json['BoxOffice']),
      production: _nullableString(json['Production']),
      website: _nullableString(json['Website']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbID,
      'Title': title,
      'Year': year,
      'Type': type,
      'Poster': poster,
      if (rated != null) 'Rated': rated,
      if (released != null) 'Released': released,
      if (runtime != null) 'Runtime': runtime,
      if (genre != null) 'Genre': genre,
      if (director != null) 'Director': director,
      if (writer != null) 'Writer': writer,
      if (actors != null) 'Actors': actors,
      if (plot != null) 'Plot': plot,
      if (language != null) 'Language': language,
      if (country != null) 'Country': country,
      if (awards != null) 'Awards': awards,
      if (ratings != null)
        'Ratings': ratings!
            .map((r) => {'Source': r.source, 'Value': r.value})
            .toList(),
      if (metascore != null) 'Metascore': metascore,
      if (imdbRating != null) 'imdbRating': imdbRating,
      if (imdbVotes != null) 'imdbVotes': imdbVotes,
      if (dvd != null) 'DVD': dvd,
      if (boxOffice != null) 'BoxOffice': boxOffice,
      if (production != null) 'Production': production,
      if (website != null) 'Website': website,
    };
  }
}
