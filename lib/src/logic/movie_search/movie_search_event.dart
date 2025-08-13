import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();
  @override
  List<Object?> get props => [];
}

class MovieSearchRequested extends MovieSearchEvent {
  final String query;
  final String? type;
  final String? year;
  const MovieSearchRequested(this.query, {this.type, this.year});
  @override
  List<Object?> get props => [query, type, year];
}

class MovieSearchLoadMore extends MovieSearchEvent {
  const MovieSearchLoadMore();
}
