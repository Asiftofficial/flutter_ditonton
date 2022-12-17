import 'package:bloc_test/bloc_test.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_bloc.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_event.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_state.dart';
import 'package:tv/presentation/pages/now_playing_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../tv/test/dummy_data/dummy_objects.dart';

class MockNowPlayingTvBloc
    extends MockBloc<NowPlayingTvEvent, NowPlayingTvState>
    implements NowPlayingTvBloc {}

class NowPlayingTvEventFake extends Fake implements NowPlayingTvEvent {}

class NowPlayingTvStateFake extends Fake implements NowPlayingTvState {}

void main() {
  late MockNowPlayingTvBloc bloc;

  setUpAll(() {
    registerFallbackValue(NowPlayingTvEventFake());
    registerFallbackValue(NowPlayingTvStateFake());
  });

  setUp(() {
    bloc = MockNowPlayingTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingTvBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('page should display loading bar center when loading',
      (WidgetTester tester) async {
    //arrange
    when(() => bloc.state).thenReturn(NowPlayingTvLoading());
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    //act
    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvPage()));

    //assert
    expect(progressBarFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('page should display listview when data is loaded',
      (WidgetTester tester) async {
    //arrange
    when(() => bloc.state).thenReturn(NowPlayingTvHasData(testTvList));

    final listviewFinder = find.byType(ListView);

    //act
    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvPage()));

    //assert
    expect(listviewFinder, findsOneWidget);
  });

  testWidgets('page should display text message when error',
      (WidgetTester tester) async {
    //arrange
    when(() => bloc.state).thenReturn(NowPlayingTvError('Server Failure'));
    final textFinder = find.byKey(Key('error_message'));

    //act
    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvPage()));

    //assert
    expect(textFinder, findsOneWidget);
  });
}
