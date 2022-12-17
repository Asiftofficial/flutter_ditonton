import 'package:movie/presentation/bloc/search_movie/search_movie_event.dart';
import 'package:movie/presentation/bloc/search_movie/search_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/usecases/search_movies.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies _searchMovies;

  SearchMovieBloc(this._searchMovies) : super(SearchMovieEmpty()) {
    on<FetchSearchMovie>((event, emit) async {
      final query = event.query;

      emit(SearchMovieLoading());

      final result = await _searchMovies.execute(query);

      result.fold((l) {
        emit(SearchMovieError(l.message));
      }, (r) {
        emit(SearchMovieHasData(r));
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
