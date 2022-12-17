import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_detail.dart';

abstract class WatchlistTvStatusEvent extends Equatable {
  const WatchlistTvStatusEvent();

  @override
  List<Object?> get props => [];
}

class SaveTvWatchlist extends WatchlistTvStatusEvent {
  final TvDetail tvDetail;

  SaveTvWatchlist(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class RemoveTvFromWatchlist extends WatchlistTvStatusEvent {
  final TvDetail tvDetail;

  RemoveTvFromWatchlist(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class LoadWatchlistTvStatus extends WatchlistTvStatusEvent {
  final int id;

  LoadWatchlistTvStatus(this.id);

  @override
  List<Object?> get props => [id];
}
