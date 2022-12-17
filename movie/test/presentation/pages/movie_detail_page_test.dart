import 'package:bloc_test/bloc_test.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:movie/presentation/bloc/watchlist_movie_status/watchlist_movie_status_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie_status/watchlist_movie_status_event.dart';
import 'package:movie/presentation/bloc/watchlist_movie_status/watchlist_movie_status_state.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MockWatchlistMovieStatusBloc
    extends MockBloc<WatchlistMovieStatusEvent, WatchlistMovieStatusState>
    implements WatchlistMovieStatusBloc {}

class WatchlistMovieStatusEventFake extends Fake
    implements WatchlistMovieStatusEvent {}

class WatchlistMovieStatusStateFake extends Fake
    implements WatchlistMovieStatusState {}

void main() {
  late MockWatchlistMovieStatusBloc mockWatchlistMovieStatusBloc;
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());

    registerFallbackValue(WatchlistMovieStatusEventFake());
    registerFallbackValue(WatchlistMovieStatusStateFake());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockWatchlistMovieStatusBloc = MockWatchlistMovieStatusBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (context) => mockMovieDetailBloc,
        ),
        BlocProvider<WatchlistMovieStatusBloc>(
          create: (context) => mockWatchlistMovieStatusBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.add(FetchMovieDetail(1))).thenAnswer(
      (_) async => {},
    );
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailHasData(
        movieDetail: testMovieDetail, recommendationResult: testMovieList));
    when(() => mockWatchlistMovieStatusBloc.add(LoadWatchlistStatus(1)))
        .thenAnswer(
      (_) async => {},
    );
    when(() => mockWatchlistMovieStatusBloc.state)
        .thenReturn(WatchlistMovieStatusState('', false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.add(FetchMovieDetail(1))).thenAnswer(
      (_) async => {},
    );
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailHasData(
        movieDetail: testMovieDetail, recommendationResult: testMovieList));
    when(() => mockWatchlistMovieStatusBloc.add(LoadWatchlistStatus(1)))
        .thenAnswer(
      (_) async => {},
    );
    when(() => mockWatchlistMovieStatusBloc.state)
        .thenReturn(WatchlistMovieStatusState('', true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailHasData(
        movieDetail: testMovieDetail, recommendationResult: testMovieList));

    when(() => mockWatchlistMovieStatusBloc.add(LoadWatchlistStatus(1)))
        .thenAnswer(
      (_) async => {},
    );
    final expectedState = [
      WatchlistMovieStatusState('Added to Watchlist', true),
    ];
    whenListen(mockWatchlistMovieStatusBloc, Stream.fromIterable(expectedState),
        initialState: WatchlistMovieStatusState('', false));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailHasData(
        movieDetail: testMovieDetail, recommendationResult: testMovieList));

    when(() => mockWatchlistMovieStatusBloc.add(LoadWatchlistStatus(1)))
        .thenAnswer(
      (_) async => {},
    );
    final expectedState = [
      WatchlistMovieStatusState('Failed', false),
    ];
    whenListen(mockWatchlistMovieStatusBloc, Stream.fromIterable(expectedState),
        initialState: WatchlistMovieStatusState('', false));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
