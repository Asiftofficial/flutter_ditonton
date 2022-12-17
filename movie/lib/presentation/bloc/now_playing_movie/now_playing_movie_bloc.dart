import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_now_playing_movies.dart';
import 'now_playing_movie_event.dart';
import 'now_playing_movie_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovie;

  NowPlayingMovieBloc(this._getNowPlayingMovie)
      : super(NowPlayingMovieEmpty()) {
    on<FetchNowPlayingMovie>((event, emit) async {
      emit(NowPlayingMovieLoading());

      final result = await _getNowPlayingMovie.execute();

      result.fold((l) {
        emit(NowPlayingMovieError(l.message));
      }, (r) {
        emit(NowPlayingMovieHasData(r));
      });
    });
  }
}
