import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/now_playing_tv/now_playing_tv_bloc.dart';
import '../bloc/now_playing_tv/now_playing_tv_event.dart';
import '../bloc/now_playing_tv/now_playing_tv_state.dart';
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
    Future.microtask(
        () => context.read<NowPlayingTvBloc>().add(FetchNowPlayingTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvBloc, NowPlayingTvState>(
            builder: ((context, state) {
          if (state is NowPlayingTvLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NowPlayingTvHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TvCard(tv); //TvCard
              },
              itemCount: state.result.length,
            );
          } else if (state is NowPlayingTvError) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Expanded(child: Container());
          }
        })),
      ),
    );
  }
}
