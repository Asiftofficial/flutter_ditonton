import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/presentation/provider/now_playing_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv])
void main() {
  late NowPlayingTvNotifier notifier;
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late int listnerCallCount;

  setUp(() {
    listnerCallCount = 0;
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    notifier = NowPlayingTvNotifier(mockGetNowPlayingTv)
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

  group('now playing tv', () {
    test('should change state to loading when usecase is called', () {
      //arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(tTvList));

      //act
      notifier.fetchNowPlayingTv();

      //assert
      expect(notifier.state, RequestState.Loading);
      expect(listnerCallCount, 1);
    });

    test('should change tv when data is gotten successfully', () async {
      //arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(tTvList));

      //act
      await notifier.fetchNowPlayingTv();

      //assert
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tv, tTvList);
      expect(listnerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      //arrange
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      //act
      await notifier.fetchNowPlayingTv();

      //assert
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listnerCallCount, 2);
    });
  });
}
