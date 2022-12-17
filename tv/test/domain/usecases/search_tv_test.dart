import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTv searchTv;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    searchTv = SearchTv(mockTvRepository);
  });

  final tQuery = 'Red';
  final tTv = <Tv>[];

  test('should get search result of tv list from repository', () async {
    //arrange
    when(mockTvRepository.searchTv(tQuery)).thenAnswer((_) async => Right(tTv));

    //act
    final result = await searchTv.execute(tQuery);

    //assert
    verify(mockTvRepository.searchTv(tQuery));
    expect(result, Right(tTv));
  });
}
