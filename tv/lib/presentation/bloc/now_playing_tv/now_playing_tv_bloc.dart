import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'now_playing_tv_event.dart';
import 'now_playing_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetNowPlayingTv _getNowPlayingTv;

  NowPlayingTvBloc(this._getNowPlayingTv) : super(NowPlayingTvEmpty()) {
    on<FetchNowPlayingTv>((event, emit) async {
      emit(NowPlayingTvLoading());

      final result = await _getNowPlayingTv.execute();

      result.fold((l) {
        emit(NowPlayingTvError(l.message));
      }, (r) {
        emit(NowPlayingTvHasData(r));
      });
    });
  }
}
