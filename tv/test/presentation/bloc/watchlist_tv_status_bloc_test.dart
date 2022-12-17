import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watchlist_tv_status/watchlist_tv_status_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv_status/watchlist_tv_status_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv_status/watchlist_tv_status_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../tv/test/dummy_data/dummy_objects.dart';
import 'watchlist_tv_status_bloc_test.mocks.dart';

@GenerateMocks([SaveWatchlistTv, RemoveWatchlistTv, GetWatchlistTvStatus])
void main() {
  late WatchlistTvStatusBloc bloc;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late MockGetWatchlistTvStatus mockGetWatchlistTvStatus;

  setUp(() {
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    mockGetWatchlistTvStatus = MockGetWatchlistTvStatus();
    bloc = WatchlistTvStatusBloc(
        saveWatchlistTv: mockSaveWatchlistTv,
        removeWatchlistTv: mockRemoveWatchlistTv,
        getWatchlistTvStatus: mockGetWatchlistTvStatus);
  });

  final tId = 1;

  test('initial state should be empty message and false added status', () {
    expect(bloc.state.message, '');
    expect(bloc.state.isAddedToWatchlist, false);
  });

  blocTest<WatchlistTvStatusBloc, WatchlistTvStatusState>(
    'should emit empty message and added status',
    build: () {
      when(mockGetWatchlistTvStatus.execute(tId)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistTvStatus(tId)),
    expect: () => [
      WatchlistTvStatusState('', true),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvStatus.execute(tId));
    },
  );

  blocTest<WatchlistTvStatusBloc, WatchlistTvStatusState>(
    'should emit message and added status when save watchlist function is called',
    build: () {
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistTvStatus.execute(tId)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(SaveTvWatchlist(testTvDetail)),
    expect: () => [
      WatchlistTvStatusState('Added to Watchlist', true),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTv.execute(testTvDetail));
      verify(mockGetWatchlistTvStatus.execute(tId));
    },
  );

  blocTest<WatchlistTvStatusBloc, WatchlistTvStatusState>(
    'should emit message and added status when remove watchlist function is called',
    build: () {
      when(mockRemoveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchlistTvStatus.execute(tId))
          .thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(RemoveTvFromWatchlist(testTvDetail)),
    expect: () => [
      WatchlistTvStatusState('Removed from Watchlist', false),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTv.execute(testTvDetail));
      verify(mockGetWatchlistTvStatus.execute(tId));
    },
  );
}
