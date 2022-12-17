import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  }) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      final id = event.id;

      emit(MovieDetailLoading());

      final movieResult = await getMovieDetail.execute(id);
      final recResult = await getMovieRecommendations.execute(id);

      movieResult.fold((l) {
        emit(MovieDetailError(l.message));
      }, (movie) {
        recResult.fold((l) {
          emit(MovieDetailError(l.message));
        }, (movies) {
          emit(MovieDetailHasData(
              movieDetail: movie, recommendationResult: movies));
        });
      });
    });
  }
}
