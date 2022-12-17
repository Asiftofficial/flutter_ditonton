import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../tv/test/dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late WatchlistTvBloc bloc;
  late MockGetWatchlistTv mockGetWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    bloc = WatchlistTvBloc(
      mockGetWatchlistTv,
    );
  });

  group('watchlist tv', () {
    test('initial state should be empty', () {
      expect(bloc.state, WatchlistTvEmpty());
    });

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should emit [loading, hasdata] when data gotten successfully',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Right([testWatchlistTv]));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvHasData([testWatchlistTv]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should emit [error, hasdata] when data gotten unsuccessfully',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
      },
    );
  });
}
