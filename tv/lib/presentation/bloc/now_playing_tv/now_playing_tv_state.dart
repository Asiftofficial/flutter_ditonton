import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class NowPlayingTvState extends Equatable {
  const NowPlayingTvState();

  @override
  List<Object?> get props => [];
}

class NowPlayingTvEmpty extends NowPlayingTvState {}

class NowPlayingTvLoading extends NowPlayingTvState {}

class NowPlayingTvHasData extends NowPlayingTvState {
  final List<Tv> result;

  NowPlayingTvHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class NowPlayingTvError extends NowPlayingTvState {
  final String message;

  NowPlayingTvError(this.message);

  @override
  List<Object?> get props => [message];
}
