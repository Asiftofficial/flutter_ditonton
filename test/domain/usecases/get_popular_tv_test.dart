import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTv getPopularTv;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getPopularTv = GetPopularTv(mockTvRepository);
  });

  final tTv = <Tv>[];

  test('should get list popular tv from repository', () async {
    //arrange
    when(mockTvRepository.getPopularTv()).thenAnswer((_) async => Right(tTv));

    //act
    final result = await getPopularTv.execute();

    //assert
    verify(mockTvRepository.getPopularTv());
    expect(result, Right(tTv));
  });
}
