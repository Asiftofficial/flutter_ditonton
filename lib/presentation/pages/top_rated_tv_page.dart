import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../widgets/tv_card_list.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';
  @override
  State<StatefulWidget> createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedTvNotifier>(context, listen: false)
            .fetchTopRatedTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTvNotifier>(builder: ((context, value, child) {
          if (value.state == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (value.state == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = value.tv[index];
                return TvCard(tv); //TvCard
              },
              itemCount: value.tv.length,
            );
          } else {
            return Center(
              key: Key('error_message'),
              child: Text(value.message),
            );
          }
        })),
      ),
    );
  }
}
