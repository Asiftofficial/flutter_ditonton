import 'package:equatable/equatable.dart';

abstract class NowPlayingTvEvent extends Equatable {
  const NowPlayingTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchNowPlayingTv extends NowPlayingTvEvent {
  const FetchNowPlayingTv();

  @override
  List<Object?> get props => [];
}
