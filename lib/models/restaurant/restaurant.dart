import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';
part 'restaurant.g.dart';

@freezed
class Restaurant with _$Restaurant {
  factory Restaurant(
      {required int id,
      required String name,
      required String address,
      required String description,
      @JsonKey(name: 'opening_hours')
          required String openingHours,
      @JsonKey(name: 'telephone_number')
          required String telephoneNumber,
      @JsonKey(name: 'reservation_advance_hours')
          required double reservationAdvanceHours,
      required String type,
      @JsonKey(name: 'primary_table_view')
          String? primaryTableView}) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}
