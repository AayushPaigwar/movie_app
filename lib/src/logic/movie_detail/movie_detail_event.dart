import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
  @override
  List<Object?> get props => [];
}

class MovieDetailRequested extends MovieDetailEvent {
  final String imdbId;
  const MovieDetailRequested(this.imdbId);
  @override
  List<Object?> get props => [imdbId];
}

class MovieDetailToggleFavorite extends MovieDetailEvent {
  const MovieDetailToggleFavorite();
}
