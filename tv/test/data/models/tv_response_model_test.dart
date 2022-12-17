import 'dart:convert';
import 'dart:ffi';

import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    adult: null,
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3],
    id: 2,
    originalTitle: "Original Title",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    releaseDate: "2020-05-05",
    title: "Title",
    video: null,
    voteAverage: 7.3,
    voteCount: 3,
  );

  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);

  group('from Json', () {
    test('should return a valid model from json', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/airing_today.json'));

      //act
      final result = TvResponse.fromJson(jsonMap);

      //assert
      expect(result, tTvResponseModel);
    });
  });

  group('to Json', () {
    test('should return json map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": null,
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3],
            "id": 2,
            "original_title": "Original Title",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "release_date": "2020-05-05",
            "title": "Title",
            "video": null,
            "vote_average": 7.3,
            "vote_count": 3
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
