import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvStatus getWatchlistTvStatus;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getWatchlistTvStatus = GetWatchlistTvStatus(mockTvRepository);
  });

  test('should get watchlist tv status from repository', () async {
    //arrange
    when(mockTvRepository.isAddedToWatchlist(1)).thenAnswer((_) async => true);

    //act
    final result = await getWatchlistTvStatus.execute(1);

    //assert
    verify(mockTvRepository.isAddedToWatchlist(1));
    expect(result, true);
  });
}
