import 'package:ditonton/presentation/provider/now_playing_tv_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../widgets/tv_card_list.dart';

class NowPlayingTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tv';
  @override
  State<StatefulWidget> createState() => _NowPlayingTvPageState();
}

class _NowPlayingTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<NowPlayingTvNotifier>(context, listen: false)
            .fetchNowPlayingTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Consumer<NowPlayingTvNotifier>(builder: ((context, value, child) {
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
