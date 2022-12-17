import 'package:movie/presentation/bloc/watchlist_movie_status/watchlist_movie_status_event.dart';
import 'package:movie/presentation/bloc/watchlist_movie_status/watchlist_movie_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_watchlist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';

class WatchlistMovieStatusBloc
    extends Bloc<WatchlistMovieStatusEvent, WatchlistMovieStatusState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  final GetWatchListStatus getWatchListStatus;

  WatchlistMovieStatusBloc({
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getWatchListStatus,
  }) : super(WatchlistMovieStatusState("", false)) {
    on<SaveMovieWatchlist>((event, emit) async {
      final movie = event.movieDetail;
      final resultMessage = await saveWatchlist.execute(movie);
      final watchlistStatus = await getWatchListStatus.execute(movie.id);

      await resultMessage.fold((l) async {
        emit(WatchlistMovieStatusState(l.message, watchlistStatus));
      }, (r) async {
        emit(WatchlistMovieStatusState(r, watchlistStatus));
      });
    });
    on<RemoveMovieFromWatchlist>((event, emit) async {
      final movie = event.movieDetail;
      final resultMessage = await removeWatchlist.execute(movie);
      final watchlistStatus = await getWatchListStatus.execute(movie.id);

      await resultMessage.fold((l) async {
        emit(WatchlistMovieStatusState(l.message, watchlistStatus));
      }, (r) async {
        emit(WatchlistMovieStatusState(r, watchlistStatus));
      });
    });
    on<LoadWatchlistStatus>((event, emit) async {
      final id = event.id;
      final watchlistStatus = await getWatchListStatus.execute(id);
      emit(WatchlistMovieStatusState('', watchlistStatus));
    });
  }
}
