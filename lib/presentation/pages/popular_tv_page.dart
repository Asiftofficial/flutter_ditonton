import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PopularTvNotifier>(context, listen: false)
            .fetchPopularTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTvNotifier>(builder: ((context, value, child) {
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