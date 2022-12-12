import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:flutter/cupertino.dart';

class NowPlayingTvNotifier extends ChangeNotifier {
  final GetNowPlayingTv getNowPlayingTv;

  NowPlayingTvNotifier(this.getNowPlayingTv);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tv = <Tv>[];
  List<Tv> get tv => _tv;

  String _message = '';
  String get message => _message;

  Future<void> fetchNowPlayingTv() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTv.execute();
    result.fold((l) {
      _state = RequestState.Error;
      _message = l.message;
      notifyListeners();
    }, (r) {
      _state = RequestState.Loaded;
      _tv = r;
      notifyListeners();
    });
  }
}
