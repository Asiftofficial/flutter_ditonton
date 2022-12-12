import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations getTvRecommendations;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getTvRecommendations = GetTvRecommendations(mockTvRepository);
  });

  final tId = 1;
  final tTv = <Tv>[];

  test('should get recommendation list of tv from repository', () async {
    //arrange
    when(mockTvRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTv));

    //act
    final result = await getTvRecommendations.execute(tId);

    //assert
    verify(mockTvRepository.getTvRecommendations(tId));
    expect(result, Right(tTv));
  });
}
