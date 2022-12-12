import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late PopularTvNotifier notifier;
  late MockGetPopularTv mockGetPopularTv;
  late int listnerCallCount;

  setUp(() {
    listnerCallCount = 0;
    mockGetPopularTv = MockGetPopularTv();
    notifier = PopularTvNotifier(mockGetPopularTv)
      ..addListener(() {
        listnerCallCount++;
      });
  });

  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvList = <Tv>[tTv];

  group('popular tv', () {
    test('should change state to loading when usecase is called', () {
      //arrange
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      notifier.fetchPopularTv();

      //assert
      expect(notifier.state, RequestState.Loading);
      expect(listnerCallCount, 1);
    });

    test('should change tv when data is gotten successfully', () async {
      //arrange
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      await notifier.fetchPopularTv();

      //assert
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tv, tTvList);
      expect(listnerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      //arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      //act
      await notifier.fetchPopularTv();

      //assert
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listnerCallCount, 2);
    });
  });
}
