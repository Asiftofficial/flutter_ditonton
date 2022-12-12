import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv, GetPopularTv, GetTopRatedTv])
void main() {
  late TvListNotifier provider;
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    provider = TvListNotifier(
      getNowPlayingTv: mockGetNowPlayingTv,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    )..addListener(() {
        listenerCallCount += 1;
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

  group('now playing tv', () {
    test('initialState should be empty', () {
      expect(provider.nowPlayingState, equals(RequestState.Empty));
    });

    test('should get data from usecase', () async {
      //arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(tTvList));

      //act
      provider.fetchNowPlayingTv();

      //assert
      verify(mockGetNowPlayingTv.execute());
    });

    test('should change state to loading when usecase is called', () {
      //arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(tTvList));

      //act
      provider.fetchNowPlayingTv();

      //assert
      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test('should change tv when data is gotten successfully', () async {
      //arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(tTvList));

      //act
      await provider.fetchNowPlayingTv();

      //assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlayingTv, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      //arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      //act
      await provider.fetchNowPlayingTv();

      //assert
      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv', () {
    test('initialState should be empty', () {
      expect(provider.popularTvState, equals(RequestState.Empty));
    });

    test('should get data from usecase', () async {
      //arrange
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      provider.fetchPopularTv();

      //assert
      verify(mockGetPopularTv.execute());
    });

    test('should change state to loading when usecase is called', () {
      //arrange
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      provider.fetchPopularTv();

      //assert
      expect(provider.popularTvState, RequestState.Loading);
    });

    test('should change tv when data is gotten successfully', () async {
      //arrange
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      await provider.fetchPopularTv();

      //assert
      expect(provider.popularTvState, RequestState.Loaded);
      expect(provider.popularTv, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      //arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      //act
      await provider.fetchPopularTv();

      //assert
      expect(provider.popularTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv', () {
    test('initialState should be empty', () {
      expect(provider.topRatedTvState, equals(RequestState.Empty));
    });

    test('should get data from usecase', () async {
      //arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      provider.fetchTopRatedTv();

      //assert
      verify(mockGetTopRatedTv.execute());
    });

    test('should change state to loading when usecase is called', () {
      //arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      provider.fetchTopRatedTv();

      //assert
      expect(provider.topRatedTvState, RequestState.Loading);
    });

    test('should change tv when data is gotten successfully', () async {
      //arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      await provider.fetchTopRatedTv();

      //assert
      expect(provider.topRatedTvState, RequestState.Loaded);
      expect(provider.topRatedTv, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      //arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      //act
      await provider.fetchTopRatedTv();

      //assert
      expect(provider.topRatedTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
