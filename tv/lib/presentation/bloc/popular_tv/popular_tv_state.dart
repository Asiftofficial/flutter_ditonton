import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class PopularTvState extends Equatable {
  const PopularTvState();

  @override
  List<Object?> get props => [];
}

class PopularTvEmpty extends PopularTvState {}

class PopularTvLoading extends PopularTvState {}

class PopularTvHasData extends PopularTvState {
  final List<Tv> result;

  PopularTvHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class PopularTvError extends PopularTvState {
  final String message;

  PopularTvError(this.message);

  @override
  List<Object?> get props => [message];
}
