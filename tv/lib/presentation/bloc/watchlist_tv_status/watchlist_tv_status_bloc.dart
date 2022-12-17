import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watchlist_tv_status/watchlist_tv_status_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv_status/watchlist_tv_status_state.dart';

class WatchlistTvStatusBloc
    extends Bloc<WatchlistTvStatusEvent, WatchlistTvStatusState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;
  final GetWatchlistTvStatus getWatchlistTvStatus;

  WatchlistTvStatusBloc({
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
    required this.getWatchlistTvStatus,
  }) : super(WatchlistTvStatusState("", false)) {
    on<SaveTvWatchlist>((event, emit) async {
      final tv = event.tvDetail;
      final resultMessage = await saveWatchlistTv.execute(tv);
      final watchlistStatus = await getWatchlistTvStatus.execute(tv.id);

      await resultMessage.fold((l) async {
        emit(WatchlistTvStatusState(l.message, watchlistStatus));
      }, (r) async {
        emit(WatchlistTvStatusState(r, watchlistStatus));
      });
    });
    on<RemoveTvFromWatchlist>((event, emit) async {
      final tv = event.tvDetail;
      final resultMessage = await removeWatchlistTv.execute(tv);
      final watchlistStatus = await getWatchlistTvStatus.execute(tv.id);

      await resultMessage.fold((l) async {
        emit(WatchlistTvStatusState(l.message, watchlistStatus));
      }, (r) async {
        emit(WatchlistTvStatusState(r, watchlistStatus));
      });
    });
    on<LoadWatchlistTvStatus>((event, emit) async {
      final id = event.id;
      final watchlistStatus = await getWatchlistTvStatus.execute(id);
      emit(WatchlistTvStatusState('', watchlistStatus));
    });
  }
}
