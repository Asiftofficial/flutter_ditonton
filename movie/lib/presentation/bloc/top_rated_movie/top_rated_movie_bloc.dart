import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_event.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_top_rated_movies.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieBloc(this._getTopRatedMovies) : super(TopRatedMovieEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedMovieLoading());

      final result = await _getTopRatedMovies.execute();

      result.fold((l) {
        emit(TopRatedMovieError(l.message));
      }, (r) {
        emit(TopRatedMovieHasData(r));
      });
    });
  }
}
