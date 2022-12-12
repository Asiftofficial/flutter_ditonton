import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_detail_response.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockTvRemoteDataSource;
  late MockTvLocalDataSource mockTvLocalDataSource;

  setUp(() {
    mockTvLocalDataSource = MockTvLocalDataSource();
    mockTvRemoteDataSource = MockTvRemoteDataSource();
    repository = TvRepositoryImpl(
        remoteDataSource: mockTvRemoteDataSource,
        localDataSource: mockTvLocalDataSource);
  });

  final tTvModel = TvModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTv = Tv(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('get now playing tv', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getNowPlayingTv())
          .thenAnswer((_) async => tTvModelList);

      //act
      final result = await repository.getNowPlayingTv();

      //assert
      verify(mockTvRemoteDataSource.getNowPlayingTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is failed',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getNowPlayingTv())
          .thenThrow(ServerException());

      //act
      final result = await repository.getNowPlayingTv();

      //assert
      verify(mockTvRemoteDataSource.getNowPlayingTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device is not connected to internet',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getNowPlayingTv())
          .thenThrow(SocketException('Failed to connect to the network'));

      //act
      final result = await repository.getNowPlayingTv();

      //assert
      verify(mockTvRemoteDataSource.getNowPlayingTv());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('get popular tv', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getPopularTv())
          .thenAnswer((_) async => tTvModelList);

      //act
      final result = await repository.getPopularTv();

      //assert
      verify(mockTvRemoteDataSource.getPopularTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is failed',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getPopularTv()).thenThrow(ServerException());

      //act
      final result = await repository.getPopularTv();

      //assert
      verify(mockTvRemoteDataSource.getPopularTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device is not connected to internet',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getPopularTv())
          .thenThrow(SocketException('Failed to connect to the network'));

      //act
      final result = await repository.getPopularTv();

      //assert
      verify(mockTvRemoteDataSource.getPopularTv());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('get top rated tv', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getTopRatedTv())
          .thenAnswer((_) async => tTvModelList);

      //act
      final result = await repository.getTopRatedTv();

      //assert
      verify(mockTvRemoteDataSource.getTopRatedTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is failed',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getTopRatedTv()).thenThrow(ServerException());

      //act
      final result = await repository.getTopRatedTv();

      //assert
      verify(mockTvRemoteDataSource.getTopRatedTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device is not connected to internet',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getTopRatedTv())
          .thenThrow(SocketException('Failed to connect to the network'));

      //act
      final result = await repository.getTopRatedTv();

      //assert
      verify(mockTvRemoteDataSource.getTopRatedTv());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return tv detail data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvResponse);
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(testTvDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('get recommendations tv', () {
    final tId = 1;
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getTvRecommendations(tId))
          .thenAnswer((_) async => tTvModelList);

      //act
      final result = await repository.getTvRecommendations(tId);

      //assert
      verify(mockTvRemoteDataSource.getTvRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is failed',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(ServerException());

      //act
      final result = await repository.getTvRecommendations(tId);

      //assert
      verify(mockTvRemoteDataSource.getTvRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device is not connected to internet',
        () async {
      //arrange
      when(mockTvRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));

      //act
      final result = await repository.getTvRecommendations(tId);

      //assert
      verify(mockTvRemoteDataSource.getTvRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('search tv', () {
    final tSearchTv = 'spiderman';
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      //arrange
      when(mockTvRemoteDataSource.searchTv(tSearchTv))
          .thenAnswer((_) async => tTvModelList);

      //act
      final result = await repository.searchTv(tSearchTv);

      //assert
      verify(mockTvRemoteDataSource.searchTv(tSearchTv));
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is failed',
        () async {
      //arrange
      when(mockTvRemoteDataSource.searchTv(tSearchTv))
          .thenThrow(ServerException());

      //act
      final result = await repository.searchTv(tSearchTv);

      //assert
      verify(mockTvRemoteDataSource.searchTv(tSearchTv));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device is not connected to internet',
        () async {
      //arrange
      when(mockTvRemoteDataSource.searchTv(tSearchTv))
          .thenThrow(SocketException('Failed to connect to the network'));

      //act
      final result = await repository.searchTv(tSearchTv);

      //assert
      verify(mockTvRemoteDataSource.searchTv(tSearchTv));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('get watchlist tv', () {
    test('should return watchlist tv list', () async {
      //arrange
      when(mockTvLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);

      //act
      final result = await repository.getWatchlistTv();

      //assert
      verify(mockTvLocalDataSource.getWatchlistTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });

  group('get watchlist tv status', () {
    final tId = 1;

    test('should return tv watchlist status', () async {
      //arrange
      when(mockTvLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);

      //act
      final result = await repository.isAddedToWatchlist(tId);

      expect(result, false);
    });
  });

  group('save watchlist tv', () {
    test('should return success message when insert to database is successful',
        () async {
      //arrange
      when(mockTvLocalDataSource.insertTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      //act
      final result = await repository.saveWatchlist(testTvDetail);

      //assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return database failure when insert to database is failed',
        () async {
      //arrange
      when(mockTvLocalDataSource.insertTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));

      //act
      final result = await repository.saveWatchlist(testTvDetail);

      //assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist tv', () {
    test(
        'should return success message when remove from database is successful',
        () async {
      //arrange
      when(mockTvLocalDataSource.removeTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from Watchlist');

      //act
      final result = await repository.removeWatchlist(testTvDetail);

      //assert
      expect(result, Right('Removed from Watchlist'));
    });

    test('should return database failure when remove from database is failed',
        () async {
      //arrange
      when(mockTvLocalDataSource.removeTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));

      //act
      final result = await repository.removeWatchlist(testTvDetail);

      //assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });
}
