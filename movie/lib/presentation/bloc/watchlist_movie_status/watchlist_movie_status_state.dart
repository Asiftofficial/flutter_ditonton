import 'package:equatable/equatable.dart';

class WatchlistMovieStatusState extends Equatable {
  final String message;
  final bool isAddedToWatchlist;

  WatchlistMovieStatusState(this.message, this.isAddedToWatchlist);

  @override
  List<Object?> get props => [message, isAddedToWatchlist];
}
