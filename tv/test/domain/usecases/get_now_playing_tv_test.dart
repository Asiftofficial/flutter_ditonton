import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTv getNowPlayingTv;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getNowPlayingTv = GetNowPlayingTv(mockTvRepository);
  });

  final tTv = <Tv>[];

  test('should get list of tv from repository', () async {
    //arrange
    when(mockTvRepository.getNowPlayingTv())
        .thenAnswer((_) async => Right(tTv));

    //act
    final result = await getNowPlayingTv.execute();

    //assert
    verify(mockTvRepository.getNowPlayingTv());
    expect(result, Right(tTv));
  });
}
