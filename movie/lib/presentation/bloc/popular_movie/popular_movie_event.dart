import 'package:equatable/equatable.dart';

abstract class PopularMovieEvent extends Equatable {
  const PopularMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularMovies extends PopularMovieEvent {
  const FetchPopularMovies();

  @override
  List<Object?> get props => [];
}
