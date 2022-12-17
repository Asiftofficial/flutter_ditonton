import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object?> get props => [];
}

class TopRatedTvEmpty extends TopRatedTvState {}

class TopRatedTvLoading extends TopRatedTvState {}

class TopRatedTvHasData extends TopRatedTvState {
  final List<Tv> result;

  TopRatedTvHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class TopRatedTvError extends TopRatedTvState {
  final String message;

  TopRatedTvError(this.message);

  @override
  List<Object?> get props => [message];
}
