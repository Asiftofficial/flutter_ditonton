import 'package:bloc_test/bloc_test.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_event.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_state.dart';
import 'package:tv/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../tv/test/dummy_data/dummy_objects.dart';

class MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

class TopRatedTvEventFake extends Fake implements TopRatedTvEvent {}

class TopRatedTvStateFake extends Fake implements TopRatedTvState {}

void main() {
  late MockTopRatedTvBloc bloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTvEventFake());
    registerFallbackValue(TopRatedTvStateFake());
  });

  setUp(() {
    bloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('page should display loading bar center when loading',
      (WidgetTester tester) async {
    //arrange
    when(() => bloc.state).thenReturn(TopRatedTvLoading());
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    //act
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    //assert
    expect(progressBarFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('page should display listview when data is loaded',
      (WidgetTester tester) async {
    //arrange
    when(() => bloc.state).thenReturn(TopRatedTvHasData(testTvList));
    final listviewFinder = find.byType(ListView);

    //act
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    //assert
    expect(listviewFinder, findsOneWidget);
  });

  testWidgets('page should display text message when error',
      (WidgetTester tester) async {
    //arrange
    when(() => bloc.state).thenReturn(TopRatedTvError('Server Failure'));
    final textFinder = find.byKey(Key('error_message'));

    //act
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    //assert
    expect(textFinder, findsOneWidget);
  });
}
