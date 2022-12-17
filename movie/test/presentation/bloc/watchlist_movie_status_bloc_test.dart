import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/watchlist_movie_status/watchlist_movie_status_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie_status/watchlist_movie_status_event.dart';
import 'package:movie/presentation/bloc/watchlist_movie_status/watchlist_movie_status_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_status_bloc_test.mocks.dart';

@GenerateMocks([SaveWatchlist, RemoveWatchlist, GetWatchListStatus])
void main() {
  late WatchlistMovieStatusBloc bloc;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockGetWatchListStatus mockGetWatchListStatus;

  setUp(() {
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();
    bloc = WatchlistMovieStatusBloc(
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
        getWatchListStatus: mockGetWatchListStatus);
  });

  final tId = 1;

  test('initial state should be empty message and false added status', () {
    expect(bloc.state.message, '');
    expect(bloc.state.isAddedToWatchlist, false);
  });

  blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
    'should emit empty message and added status',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
    expect: () => [
      WatchlistMovieStatusState('', true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
    'should emit message and added status when save watchlist function is called',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(SaveMovieWatchlist(testMovieDetail)),
    expect: () => [
      WatchlistMovieStatusState('Added to Watchlist', true),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
    'should emit message and added status when remove watchlist function is called',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
    expect: () => [
      WatchlistMovieStatusState('Removed from Watchlist', false),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(tId));
    },
  );
}
