import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main() {
  late TopRatedTvNotifier notifier;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late int listnerCallCount;

  setUp(() {
    listnerCallCount = 0;
    mockGetTopRatedTv = MockGetTopRatedTv();
    notifier = TopRatedTvNotifier(getTopRatedTv: mockGetTopRatedTv)
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

  group('top rated tv', () {
    test('should change state to loading when usecase is called', () {
      //arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      notifier.fetchTopRatedTv();

      //assert
      expect(notifier.state, RequestState.Loading);
      expect(listnerCallCount, 1);
    });

    test('should change tv when data is gotten successfully', () async {
      //arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));

      //act
      await notifier.fetchTopRatedTv();

      //assert
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tv, tTvList);
      expect(listnerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      //arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      //act
      await notifier.fetchTopRatedTv();

      //assert
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listnerCallCount, 2);
    });
  });
}
