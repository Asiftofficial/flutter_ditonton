import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class SearchTvState extends Equatable {
  const SearchTvState();

  @override
  List<Object?> get props => [];
}

class SearchTvEmpty extends SearchTvState {}

class SearchTvLoading extends SearchTvState {}

class SearchTvError extends SearchTvState {
  final String message;

  SearchTvError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchTvHasData extends SearchTvState {
  final List<Tv> result;

  SearchTvHasData(this.result);

  @override
  List<Object?> get props => [result];
}
