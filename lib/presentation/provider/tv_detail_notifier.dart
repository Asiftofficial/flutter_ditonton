import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter/cupertino.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchlistTvStatus getWatchlistTvStatus;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchlistTvStatus,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  });

  late TvDetail _tvDetail;
  TvDetail get tvDetail => _tvDetail;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<Tv> _tvRecommendations = <Tv>[];
  List<Tv> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();

    final resultTv = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);

    resultTv.fold((l) {
      _tvState = RequestState.Error;
      _message = l.message;
      notifyListeners();
    }, (r) {
      _recommendationState = RequestState.Loading;
      _tvDetail = r;
      notifyListeners();

      recommendationResult.fold((l) {
        _recommendationState = RequestState.Error;
        _message = l.message;
      }, (r) {
        _recommendationState = RequestState.Loaded;
        _tvRecommendations = r;
      });

      _tvState = RequestState.Loaded;
      notifyListeners();
    });
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlistTv(TvDetail tvDetail) async {
    final result = await saveWatchlistTv.execute(tvDetail);

    await result.fold((l) async {
      _watchlistMessage = l.message;
    }, (r) async {
      _watchlistMessage = r;
    });

    await loadWatchlistTvStatus(tvDetail.id);
  }

  Future<void> removeFromWatchlist(TvDetail tvDetail) async {
    final result = await removeWatchlistTv.execute(tvDetail);

    await result.fold((l) async {
      _watchlistMessage = l.message;
    }, (r) async {
      _watchlistMessage = r;
    });

    await loadWatchlistTvStatus(tvDetail.id);
  }

  Future<void> loadWatchlistTvStatus(int id) async {
    final result = await getWatchlistTvStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
