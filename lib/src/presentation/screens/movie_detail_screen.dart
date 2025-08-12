import 'enhanced_movie_detail_screen.dart';

// Alias for backwards compatibility with optional hero tag passthrough
class MovieDetailScreen extends EnhancedMovieDetailScreen {
  const MovieDetailScreen({super.key, required super.imdbID, super.heroTag});
}