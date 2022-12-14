import 'package:equatable/equatable.dart';

abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchSearchTv extends SearchTvEvent {
  final String query;

  FetchSearchTv(this.query);

  @override
  List<Object?> get props => [query];
}
