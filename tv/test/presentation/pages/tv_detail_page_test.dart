import 'package:bloc_test/bloc_test.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';
import 'package:tv/presentation/bloc/watchlist_tv_status/watchlist_tv_status_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv_status/watchlist_tv_status_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv_status/watchlist_tv_status_state.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../tv/test/dummy_data/dummy_objects.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class TvDetailEventFake extends Fake implements TvDetailEvent {}

class TvDetailStateFake extends Fake implements TvDetailState {}

class MockWatchlistTvStatusBloc
    extends MockBloc<WatchlistTvStatusEvent, WatchlistTvStatusState>
    implements WatchlistTvStatusBloc {}

class WatchlistTvStatusEventFake extends Fake
    implements WatchlistTvStatusEvent {}

class WatchlistTvStatusStateFake extends Fake
    implements WatchlistTvStatusState {}

void main() {
  late MockWatchlistTvStatusBloc mockWatchlistTvStatusBloc;
  late MockTvDetailBloc mockTvDetailBloc;

  setUpAll(() {
    registerFallbackValue(TvDetailEventFake());
    registerFallbackValue(TvDetailStateFake());

    registerFallbackValue(WatchlistTvStatusEventFake());
    registerFallbackValue(WatchlistTvStatusStateFake());
  });

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
    mockWatchlistTvStatusBloc = MockWatchlistTvStatusBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailBloc>(
          create: (context) => mockTvDetailBloc,
        ),
        BlocProvider<WatchlistTvStatusBloc>(
          create: (context) => mockWatchlistTvStatusBloc,
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
    when(() => mockTvDetailBloc.add(FetchTvDetail(1))).thenAnswer(
      (_) async => {},
    );
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailHasData(
        tvDetail: testTvDetail, recommendationResult: testTvList));
    when(() => mockWatchlistTvStatusBloc.add(LoadWatchlistTvStatus(1)))
        .thenAnswer(
      (_) async => {},
    );
    when(() => mockWatchlistTvStatusBloc.state)
        .thenReturn(WatchlistTvStatusState('', false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.add(FetchTvDetail(1))).thenAnswer(
      (_) async => {},
    );
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailHasData(
        tvDetail: testTvDetail, recommendationResult: testTvList));
    when(() => mockWatchlistTvStatusBloc.add(LoadWatchlistTvStatus(1)))
        .thenAnswer(
      (_) async => {},
    );
    when(() => mockWatchlistTvStatusBloc.state)
        .thenReturn(WatchlistTvStatusState('', true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailHasData(
        tvDetail: testTvDetail, recommendationResult: testTvList));

    when(() => mockWatchlistTvStatusBloc.add(LoadWatchlistTvStatus(1)))
        .thenAnswer(
      (_) async => {},
    );
    final expectedState = [
      WatchlistTvStatusState('Added to Watchlist', true),
    ];
    whenListen(mockWatchlistTvStatusBloc, Stream.fromIterable(expectedState),
        initialState: WatchlistTvStatusState('', false));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailHasData(
        tvDetail: testTvDetail, recommendationResult: testTvList));

    when(() => mockWatchlistTvStatusBloc.add(LoadWatchlistTvStatus(1)))
        .thenAnswer(
      (_) async => {},
    );
    final expectedState = [
      WatchlistTvStatusState('Failed', false),
    ];
    whenListen(mockWatchlistTvStatusBloc, Stream.fromIterable(expectedState),
        initialState: WatchlistTvStatusState('', false));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
