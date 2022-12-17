import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/top_rated_tv/top_rated_tv_bloc.dart';
import '../bloc/top_rated_tv/top_rated_tv_event.dart';
import '../bloc/top_rated_tv/top_rated_tv_state.dart';
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
    Future.microtask(
        () => context.read<TopRatedTvBloc>().add(FetchTopRatedTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
            builder: ((context, state) {
          if (state is TopRatedTvLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TopRatedTvHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TvCard(tv); //TvCard
              },
              itemCount: state.result.length,
            );
          } else if (state is TopRatedTvError) {
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
