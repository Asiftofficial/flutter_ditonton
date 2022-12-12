import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'top_rated_tv_page_test.mocks.dart';

@GenerateMocks([TopRatedTvNotifier])
void main() {
  late MockTopRatedTvNotifier notifier;

  setUp(() {
    notifier = MockTopRatedTvNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTvNotifier>.value(
      value: notifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('page should display loading bar center when loading',
      (WidgetTester tester) async {
    //arrange
    when(notifier.state).thenReturn(RequestState.Loading);
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
    when(notifier.state).thenReturn(RequestState.Loaded);
    when(notifier.tv).thenReturn(<Tv>[]);
    final listviewFinder = find.byType(ListView);

    //act
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    //assert
    expect(listviewFinder, findsOneWidget);
  });

  testWidgets('page should display text message when error',
      (WidgetTester tester) async {
    //arrange
    when(notifier.state).thenReturn(RequestState.Error);
    when(notifier.message).thenReturn('Error message');
    final textFinder = find.byKey(Key('error_message'));

    //act
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    //assert
    expect(textFinder, findsOneWidget);
  });
}