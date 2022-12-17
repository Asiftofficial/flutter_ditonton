import 'dart:convert';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/models/tv_detail_response.dart';
import 'package:tv/data/models/tv_response.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl datasource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get now playing tv', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/airing_today.json')))
        .tvList;

    test('should return list of tv model when response code is 200', () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/airing_today.json'), 200));

      //act
      final result = await datasource.getNowPlayingTv();

      //assert
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      //act
      final result = datasource.getNowPlayingTv();

      //assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('get popular tv', () {
    final tTvList =
        TvResponse.fromJson(json.decode(readJson('dummy_data/tv_popular.json')))
            .tvList;
    test('should return popular list of tv when response code is 200',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200));

      //act
      final result = await datasource.getPopularTv();

      //assert
      expect(result, tTvList);
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      //act
      final result = datasource.getPopularTv();

      //assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('get top rated tv', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/tv_top_rated.json')))
        .tvList;
    test('should return top rated list of tv when response code is 200',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_top_rated.json'), 200));

      //act
      final result = await datasource.getTopRatedTv();

      //assert
      expect(result, tTvList);
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      //act
      final result = datasource.getTopRatedTv();

      //assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('search tv', () {
    final tSearchResult = TvResponse.fromJson(
            jsonDecode(readJson('dummy_data/search_spiderman_tv.json')))
        .tvList;
    final tQuery = 'Spiderman';
    test('should return search list of tv when response code is 200', () async {
      //arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_spiderman_tv.json'), 200));

      //act
      final result = await datasource.searchTv(tQuery);

      //assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      //arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 400));

      //act
      final result = datasource.searchTv(tQuery);

      //assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tTvRecommendations = TvResponse.fromJson(
            jsonDecode(readJson('dummy_data/tv_recommendations.json')))
        .tvList;
    final tId = 1;
    test('should return tv recommendation list when response code is 200',
        () async {
      //arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_recommendations.json'), 200));

      //act
      final result = await datasource.getTvRecommendations(tId);

      //assert
      expect(result, tTvRecommendations);
    });

    test('shoul throw ServerException when response code is other than 200',
        () async {
      //arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      //act
      final result = datasource.getTvRecommendations(tId);

      //assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('get detail tv', () {
    final tId = 1;
    final tTvDetail = TvDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));
    test('should return detail tv when response code is 200', () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));

      //act
      final result = await datasource.getTvDetail(tId);

      //assert
      expect(result, equals(tTvDetail));
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      //act
      final result = datasource.getTvDetail(tId);

      //assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });
}
