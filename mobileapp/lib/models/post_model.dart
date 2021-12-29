import 'package:hls/constants/api.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/models/_generic_model.dart';

part 'post_model.g.dart';

@JsonSerializable(includeIfNull: false)
class PaginationData {
  @JsonKey(name: 'nodes')
  List<PostData> list;
  @JsonKey(name: 'pageInfo')
  PaginationMetaData meta;

  PaginationData();

  factory PaginationData.fromJson(Map<String, dynamic> json) =>
      _$PaginationDataFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationDataToJson(this);
}

@JsonSerializable(includeIfNull: false)
class PostData extends GenericData {
  @JsonKey(
      name: 'kind',
      fromJson: PostType.fromJsonValue,
      toJson: PostType.toJsonValue)
  PostType type;
  @JsonKey(fromJson: toBool)
  bool isHalf = false;
  @JsonKey(name: 'publishedAt', fromJson: toDate)
  DateTime date;
  @JsonKey(name: 'content')
  String texts;
  List<StoryData> stories;
  String videoUrl;
  @JsonKey(name: 'videoDuration')
  int durationSeconds;

  PostData();

  // getters

  String get imageUrl => super.imageUrl.isNullOrEmpty ? null : super.imageUrl.startsWith('http')
      ? super.imageUrl
      : '$siteUrl${super.imageUrl}';

  Duration get duration => Duration(seconds: durationSeconds ?? 0);

  factory PostData.fromJson(Map<String, dynamic> json) =>
      _$PostDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostDataToJson(this);

  @override
  String toString() => 'FoodData(title: $title)';
}

@JsonSerializable(includeIfNull: false)
class StoryData extends GenericData {
  @JsonKey(name: 'text')
  List<String> texts;

  StoryData();

  factory StoryData.fromJson(Map<String, dynamic> json) =>
      _$StoryDataFromJson(json);
  Map<String, dynamic> toJson() => _$StoryDataToJson(this);
}

@JsonSerializable(includeIfNull: false)
class PaginationMetaData {
  @JsonKey(name: 'endCursor')
  String cursor;
  bool hasNextPage;

  PaginationMetaData();

  factory PaginationMetaData.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationMetaDataToJson(this);

  @override
  String toString() =>
      'PaginationMetaData(cursor: $cursor hasNextPage: $hasNextPage)';
}

class PostType extends GenericEnum<String> {
  const PostType({String value}) : super(value: value);

  static PostType fromValue(value) =>
      values.firstWhere((x) => x.value == value, orElse: () => PostType.OTHER);

  static PostType fromJsonValue(value) => fromValue(value);
  static int toJsonValue(item) => item?.value;

  static const OTHER = PostType(value: '?');
  static const ARTICLE = PostType(value: 'ARTICLE');
  static const STORY = PostType(value: 'STORY');
  static const VIDEO = PostType(value: 'VIDEO');

  static const values = [ARTICLE, STORY, VIDEO];

  @override
  String toString() => '$value';
}
