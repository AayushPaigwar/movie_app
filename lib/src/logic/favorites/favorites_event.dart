import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object?> get props => [];
}

class FavoritesRequested extends FavoritesEvent {
  const FavoritesRequested();
}

class FavoriteRemoved extends FavoritesEvent {
  final String imdbId;
  const FavoriteRemoved(this.imdbId);
  @override
  List<Object?> get props => [imdbId];
}
