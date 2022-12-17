import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv/domain/usecases/search_tv.dart';
import 'package:tv/presentation/bloc/search_tv/search_tv_event.dart';
import 'package:tv/presentation/bloc/search_tv/search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTv _searchTv;

  SearchTvBloc(this._searchTv) : super(SearchTvEmpty()) {
    on<FetchSearchTv>((event, emit) async {
      final query = event.query;

      emit(SearchTvLoading());

      final result = await _searchTv.execute(query);
      result.fold((l) {
        emit(SearchTvError(l.message));
      }, (r) {
        emit(SearchTvHasData(r));
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
