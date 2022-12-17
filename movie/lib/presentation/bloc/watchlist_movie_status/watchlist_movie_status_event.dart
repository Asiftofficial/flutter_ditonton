import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie_detail.dart';

abstract class WatchlistMovieStatusEvent extends Equatable {
  const WatchlistMovieStatusEvent();

  @override
  List<Object?> get props => [];
}

class SaveMovieWatchlist extends WatchlistMovieStatusEvent {
  final MovieDetail movieDetail;

  SaveMovieWatchlist(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

class RemoveMovieFromWatchlist extends WatchlistMovieStatusEvent {
  final MovieDetail movieDetail;

  RemoveMovieFromWatchlist(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

class LoadWatchlistStatus extends WatchlistMovieStatusEvent {
  final int id;

  LoadWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}
