import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTv removeWatchlistTv;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    removeWatchlistTv = RemoveWatchlistTv(mockTvRepository);
  });

  test('should remove tv from repository', () async {
    //arrange
    when(mockTvRepository.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Removed from Watchlist'));

    //act
    final result = await removeWatchlistTv.execute(testTvDetail);

    //assert
    verify(mockTvRepository.removeWatchlist(testTvDetail));
    expect(result, Right('Removed from Watchlist'));
  });
}
