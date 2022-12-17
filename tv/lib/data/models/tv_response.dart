import 'package:equatable/equatable.dart';
import 'package:tv/data/models/tv_model.dart';

class TvResponse extends Equatable {
  final List<TvModel> tvList;

  TvResponse({required this.tvList});

  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
        tvList: List<TvModel>.from((json["results"] as List)
            .map((e) => TvModel.fromJson(e))
            .where((element) => element.posterPath != null)),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(tvList.map((e) => e.toJson())),
      };

  @override
  // TODO: implement props
  List<Object?> get props => [tvList];
}
