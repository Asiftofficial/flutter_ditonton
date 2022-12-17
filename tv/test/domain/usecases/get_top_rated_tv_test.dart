import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTv getTopRatedTv;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getTopRatedTv = GetTopRatedTv(mockTvRepository);
  });

  final tTv = <Tv>[];

  test('should get top rated list of tv From repository', () async {
    //arrange
    when(mockTvRepository.getTopRatedTv()).thenAnswer((_) async => Right(tTv));

    //act
    final result = await getTopRatedTv.execute();

    //assert
    verify(mockTvRepository.getTopRatedTv());
    expect(result, Right(tTv));
  });
}
