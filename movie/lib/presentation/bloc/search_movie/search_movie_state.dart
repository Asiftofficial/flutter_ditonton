import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';

abstract class SearchMovieState extends Equatable {
  const SearchMovieState();

  @override
  List<Object?> get props => [];
}

class SearchMovieEmpty extends SearchMovieState {}

class SearchMovieLoading extends SearchMovieState {}

class SearchMovieHasData extends SearchMovieState {
  final List<Movie> result;

  SearchMovieHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class SearchMovieError extends SearchMovieState {
  final String message;

  SearchMovieError(this.message);

  @override
  List<Object?> get props => [message];
}
