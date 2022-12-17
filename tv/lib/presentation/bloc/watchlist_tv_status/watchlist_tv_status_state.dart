import 'package:equatable/equatable.dart';

class WatchlistTvStatusState extends Equatable {
  final String message;
  final bool isAddedToWatchlist;

  WatchlistTvStatusState(this.message, this.isAddedToWatchlist);

  @override
  List<Object?> get props => [message, isAddedToWatchlist];
}
