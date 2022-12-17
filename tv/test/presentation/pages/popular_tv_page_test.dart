import 'package:bloc_test/bloc_test.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_event.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_state.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../tv/test/dummy_data/dummy_objects.dart';

class MockPopularTvBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

class PopularTvEventFake extends Fake implements PopularTvEvent {}

class PopularTvStateFake extends Fake implements PopularTvState {}

void main() {
  late MockPopularTvBloc bloc;

  setUpAll(() {
    registerFallbackValue(PopularTvEventFake());
    registerFallbackValue(PopularTvStateFake());
  });

  setUp(() {
    bloc = MockPopularTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('page should display loading bar center when loading',
      (WidgetTester tester) async {
    //arrange
    when(() => bloc.state).thenReturn(PopularTvLoading());
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    //act
    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    //assert
    expect(progressBarFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('page should display listview when data is loaded',
      (WidgetTester tester) async {
    //arrange
    when(() => bloc.state).thenReturn(PopularTvHasData(testTvList));
    final listviewFinder = find.byType(ListView);

    //act
    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    //assert
    expect(listviewFinder, findsOneWidget);
  });

  testWidgets('page should display text message when error',
      (WidgetTester tester) async {
    //arrange
    when(() => bloc.state).thenReturn(PopularTvError('Server Failure'));
    final textFinder = find.byKey(Key('error_message'));

    //act
    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    //assert
    expect(textFinder, findsOneWidget);
  });
}
