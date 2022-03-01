// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Restaurant _$$_RestaurantFromJson(Map<String, dynamic> json) =>
    _$_Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      openingHours: json['opening_hours'] as String,
      telephoneNumber: json['telephone_number'] as String,
      reservationAdvanceHours:
          (json['reservation_advance_hours'] as num).toDouble(),
      type: json['type'] as String,
      primaryTableView: json['primary_table_view'] as String?,
    );

Map<String, dynamic> _$$_RestaurantToJson(_$_Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'description': instance.description,
      'opening_hours': instance.openingHours,
      'telephone_number': instance.telephoneNumber,
      'reservation_advance_hours': instance.reservationAdvanceHours,
      'type': instance.type,
      'primary_table_view': instance.primaryTableView,
    };
