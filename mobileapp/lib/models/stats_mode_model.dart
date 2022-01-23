import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/_generic_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stats_mode_model.g.dart';


@JsonSerializable(includeIfNull: false)
class StatsMode extends GenericData {
  @JsonKey(name: 'sleepDuration')
  int sleepDuration;
  @JsonKey(name: 'sleepReport')
  List<Object> sleepReport;



  StatsMode();

  // getters
  // @override
  // String get imageUrl => image.url;
  // bool get canExpand => children.isNullOrEmpty && foods.length > 1;

  factory StatsMode.fromJson(Map<String, dynamic> json) =>
      json.isNullOrEmpty ? null : _$StatsModeFromJson(json);
  Map<String, dynamic> toJson() => _$StatsModeToJson(this);



  @override
  String toString() => 'asleepTime('
  // '\n\tasleepTime: $asleepTime'
      '\n\tsleepReport: $sleepReport'
      ')';
}
