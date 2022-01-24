// import 'package:hls/helpers/null_awareness.dart';
// import 'package:hls/models/_generic_model.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// part 'stats_eatings_model.g.dart';
//
// @JsonSerializable(includeIfNull: false)
// class StatsEatings extends GenericData {
//   @JsonKey(name: 'foodRating')
//   StatsFoodRating foodRating;
//   @JsonKey(name: 'scheduleEatings')
//   List<StatsScheduleEatings> eatings;
//
//   StatsEatings();
//
//   factory StatsEatings.fromJson(Map<String, dynamic> json) =>
//       json.isNullOrEmpty ? null : _$StatsEatingsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatsEatingsToJson(this);
// }
//
// @JsonSerializable(includeIfNull: false)
// class StatsFoodRating {
//   @JsonKey(name: 'consumedComponents')
//   List<StatsScheduleComponents> components;
//   @JsonKey(name: 'consumedComponentsPerEating')
//   List<StatsScheduleComponentsEatings> componentsPerEating;
//   @JsonKey(name: 'primaryStats')
//   StatsPrimaryStats primaryStats;
//
//   StatsFoodRating();
//
//   // getters
//
//   factory StatsFoodRating.fromJson(Map<String, dynamic> json) =>
//       _$StatsFoodRatingFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatsFoodRatingToJson(this);
// }
//
// @JsonSerializable(includeIfNull: false)
// class StatsScheduleEatings {
//   @JsonKey(name: 'scheduleItem')
//   StatsScheduleItem scheduleItem;
//   @JsonKey(name: 'portion')
//   double portion;
//   @JsonKey(name: 'food')
//   StatsScheduleFood scheduleFood;
//   @JsonKey(name: 'id')
//   String id;
//
//   StatsScheduleEatings();
//
//   factory StatsScheduleEatings.fromJson(Map<String, dynamic> json) =>
//       _$StatsScheduleEatingsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatsScheduleEatingsToJson(this);
//
//   @override
//   String toString() => 'StatsScheduleEatings('
//       '\n\tportion: $portion'
//       ')';
// }
//
// @JsonSerializable(includeIfNull: false)
// class StatsScheduleComponentsEatings {
//   @JsonKey(name: 'stats')
//   List<ScheduleStats> statsEatings;
//   @JsonKey(name: 'scheduleItem')
//   ScheduleItem scheduleItem;
//
//   StatsScheduleComponentsEatings();
//
//   // getters
//
//   factory StatsScheduleComponentsEatings.fromJson(Map<String, dynamic> json) =>
//       _$StatsScheduleComponentsEatingsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatsScheduleComponentsEatingsToJson(this);
//
// // @override
// // String toString() => 'StatsDailyRating('
// //     '\n\tschedule: $schedule'
// //     '\n\texercise: $exercise'
// //     '\n\tnutrition: $nutrition'
// //     ')';
// }
//
// @JsonSerializable(includeIfNull: false)
// class ScheduleStats {
//   @JsonKey(name: 'limit')
//   double limit;
//   @JsonKey(name: 'value')
//   double value;
//   @JsonKey(name: 'component')
//   ComponentStats component;
//
//   ScheduleStats();
//
//   // getters
//
//   factory ScheduleStats.fromJson(Map<String, dynamic> json) =>
//       _$ScheduleStatsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ScheduleStatsToJson(this);
//
//   @override
//   String toString() => 'ScheduleStats('
//       '\n\tlimit: $limit'
//       '\n\tvalue: $value'
//       ')';
// }
//
// @JsonSerializable(includeIfNull: false)
// class ScheduleItem {
//   @JsonKey(name: 'kind')
//   String kind;
//   @JsonKey(name: 'plannedAt')
//   String plannedAt;
//
//   ScheduleItem();
//
//   // getters
//
//   factory ScheduleItem.fromJson(Map<String, dynamic> json) =>
//       _$ScheduleItemFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ScheduleItemToJson(this);
// }
//
// @JsonSerializable(includeIfNull: false)
// class StatsPrimaryStats {
//   @JsonKey(name: 'energyValue')
//   double energyValue;
//   @JsonKey(name: 'nutrients')
//   double nutrients;
//   @JsonKey(name: 'water')
//   double water;
//
//   StatsPrimaryStats();
//
//   // getters
//
//   factory StatsPrimaryStats.fromJson(Map<String, dynamic> json) =>
//       _$StatsPrimaryStatsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatsPrimaryStatsToJson(this);
//
//   @override
//   String toString() => 'StatsPrimaryStats('
//       '\n\tenergyValue: $energyValue'
//       '\n\tnutrients: $nutrients'
//       '\n\twater: $water'
//       ')';
// }
//
// @JsonSerializable(includeIfNull: false)
// class ComponentStats {
//   @JsonKey(name: 'title')
//   String title;
//
//   ComponentStats();
//
//   // getters
//
//   factory ComponentStats.fromJson(Map<String, dynamic> json) =>
//       _$ComponentStatsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ComponentStatsToJson(this);
//
//   @override
//   String toString() => 'StatsPrimaryStats('
//       '\n\ttitle: $title'
//       ')';
// }
//
// @JsonSerializable(includeIfNull: false)
// class StatsScheduleComponents {
//   @JsonKey(name: 'value')
//   double value;
//   @JsonKey(name: 'lowerLimit')
//   double lowerLimit;
//   @JsonKey(name: 'upperLimit')
//   double upperLimit;
//   @JsonKey(name: 'rating')
//   double rating;
//   @JsonKey(name: 'foodComponent')
//   StatsScheduleFoodComponents foodComponent;
//
//   StatsScheduleComponents();
//
//   // getters
//
//   factory StatsScheduleComponents.fromJson(Map<String, dynamic> json) =>
//       _$StatsScheduleComponentsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatsScheduleComponentsToJson(this);
//
// // @override
// // String toString() => 'StatsDailyRating('
// //     '\n\tschedule: $schedule'
// //     '\n\texercise: $exercise'
// //     '\n\tnutrition: $nutrition'
// //     ')';
// }
//
// @JsonSerializable(includeIfNull: false)
// class StatsScheduleFoodComponents {
//   @JsonKey(name: 'title')
//   String title;
//   @JsonKey(name: 'unit')
//   String unit;
//   @JsonKey(name: 'section')
//   String section;
//
//   StatsScheduleFoodComponents();
//
//   // getters
//
//   factory StatsScheduleFoodComponents.fromJson(Map<String, dynamic> json) =>
//       _$StatsScheduleFoodComponentsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatsScheduleFoodComponentsToJson(this);
//
//   @override
//   String toString() => 'StatsScheduleFoodComponents('
//       '\n\ttitle: $title'
//       '\n\tunit: $unit'
//       '\n\tsection: $section'
//       ')';
// }
//
// @JsonSerializable(includeIfNull: false)
// class StatsScheduleFood {
//   @JsonKey(name: 'title')
//   String title;
//
//   // @JsonKey(name: 'portion')
//   // double portion;
//   // @JsonKey(name: 'structure')
//   // List <StatsScheduleStructure> structure;
//
//   StatsScheduleFood();
//
//   // getters
//
//   factory StatsScheduleFood.fromJson(Map<String, dynamic> json) =>
//       _$StatsScheduleFoodFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatsScheduleFoodToJson(this);
//
//   @override
//   String toString() => 'StatsScheduleFood('
//       '\n\ttitle: $title'
//       // '\n\tportion: $portion'
//       ')';
// }
//
// @JsonSerializable(includeIfNull: false)
// class StatsScheduleItem {
//   @JsonKey(name: 'kind')
//   String kind;
//   @JsonKey(name: 'plannedAt')
//   String plannedAt;
//
//   StatsScheduleItem();
//
//   // getters
//
//   factory StatsScheduleItem.fromJson(Map<String, dynamic> json) =>
//       _$StatsScheduleItemFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatsScheduleItemToJson(this);
//
//   @override
//   String toString() => 'StatsScheduleItem('
//       '\n\tkind: $kind'
//       '\n\tplannedAt: $plannedAt'
//       ')';
// }
