import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
  }) : super(TvDetailEmpty()) {
    on<FetchTvDetail>((event, emit) async {
      final id = event.id;

      emit(TvDetailLoading());

      final tvResult = await getTvDetail.execute(id);
      final recResult = await getTvRecommendations.execute(id);

      tvResult.fold((l) {
        emit(TvDetailError(l.message));
      }, (tv) {
        recResult.fold((l) {
          emit(TvDetailError(l.message));
        }, (tvs) {
          emit(TvDetailHasData(tvDetail: tv, recommendationResult: tvs));
        });
      });
    });
  }
}
