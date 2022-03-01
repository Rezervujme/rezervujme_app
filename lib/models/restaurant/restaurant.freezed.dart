// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'restaurant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) {
  return _Restaurant.fromJson(json);
}

/// @nodoc
class _$RestaurantTearOff {
  const _$RestaurantTearOff();

  _Restaurant call(
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
          String? primaryTableView}) {
    return _Restaurant(
      id: id,
      name: name,
      address: address,
      description: description,
      openingHours: openingHours,
      telephoneNumber: telephoneNumber,
      reservationAdvanceHours: reservationAdvanceHours,
      type: type,
      primaryTableView: primaryTableView,
    );
  }

  Restaurant fromJson(Map<String, Object?> json) {
    return Restaurant.fromJson(json);
  }
}

/// @nodoc
const $Restaurant = _$RestaurantTearOff();

/// @nodoc
mixin _$Restaurant {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'opening_hours')
  String get openingHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'telephone_number')
  String get telephoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'reservation_advance_hours')
  double get reservationAdvanceHours => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_table_view')
  String? get primaryTableView => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RestaurantCopyWith<Restaurant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantCopyWith<$Res> {
  factory $RestaurantCopyWith(
          Restaurant value, $Res Function(Restaurant) then) =
      _$RestaurantCopyWithImpl<$Res>;
  $Res call(
      {int id,
      String name,
      String address,
      String description,
      @JsonKey(name: 'opening_hours')
          String openingHours,
      @JsonKey(name: 'telephone_number')
          String telephoneNumber,
      @JsonKey(name: 'reservation_advance_hours')
          double reservationAdvanceHours,
      String type,
      @JsonKey(name: 'primary_table_view')
          String? primaryTableView});
}

/// @nodoc
class _$RestaurantCopyWithImpl<$Res> implements $RestaurantCopyWith<$Res> {
  _$RestaurantCopyWithImpl(this._value, this._then);

  final Restaurant _value;
  // ignore: unused_field
  final $Res Function(Restaurant) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? address = freezed,
    Object? description = freezed,
    Object? openingHours = freezed,
    Object? telephoneNumber = freezed,
    Object? reservationAdvanceHours = freezed,
    Object? type = freezed,
    Object? primaryTableView = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      openingHours: openingHours == freezed
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String,
      telephoneNumber: telephoneNumber == freezed
          ? _value.telephoneNumber
          : telephoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      reservationAdvanceHours: reservationAdvanceHours == freezed
          ? _value.reservationAdvanceHours
          : reservationAdvanceHours // ignore: cast_nullable_to_non_nullable
              as double,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      primaryTableView: primaryTableView == freezed
          ? _value.primaryTableView
          : primaryTableView // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$RestaurantCopyWith<$Res> implements $RestaurantCopyWith<$Res> {
  factory _$RestaurantCopyWith(
          _Restaurant value, $Res Function(_Restaurant) then) =
      __$RestaurantCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      String name,
      String address,
      String description,
      @JsonKey(name: 'opening_hours')
          String openingHours,
      @JsonKey(name: 'telephone_number')
          String telephoneNumber,
      @JsonKey(name: 'reservation_advance_hours')
          double reservationAdvanceHours,
      String type,
      @JsonKey(name: 'primary_table_view')
          String? primaryTableView});
}

/// @nodoc
class __$RestaurantCopyWithImpl<$Res> extends _$RestaurantCopyWithImpl<$Res>
    implements _$RestaurantCopyWith<$Res> {
  __$RestaurantCopyWithImpl(
      _Restaurant _value, $Res Function(_Restaurant) _then)
      : super(_value, (v) => _then(v as _Restaurant));

  @override
  _Restaurant get _value => super._value as _Restaurant;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? address = freezed,
    Object? description = freezed,
    Object? openingHours = freezed,
    Object? telephoneNumber = freezed,
    Object? reservationAdvanceHours = freezed,
    Object? type = freezed,
    Object? primaryTableView = freezed,
  }) {
    return _then(_Restaurant(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      openingHours: openingHours == freezed
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String,
      telephoneNumber: telephoneNumber == freezed
          ? _value.telephoneNumber
          : telephoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      reservationAdvanceHours: reservationAdvanceHours == freezed
          ? _value.reservationAdvanceHours
          : reservationAdvanceHours // ignore: cast_nullable_to_non_nullable
              as double,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      primaryTableView: primaryTableView == freezed
          ? _value.primaryTableView
          : primaryTableView // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Restaurant implements _Restaurant {
  _$_Restaurant(
      {required this.id,
      required this.name,
      required this.address,
      required this.description,
      @JsonKey(name: 'opening_hours')
          required this.openingHours,
      @JsonKey(name: 'telephone_number')
          required this.telephoneNumber,
      @JsonKey(name: 'reservation_advance_hours')
          required this.reservationAdvanceHours,
      required this.type,
      @JsonKey(name: 'primary_table_view')
          this.primaryTableView});

  factory _$_Restaurant.fromJson(Map<String, dynamic> json) =>
      _$$_RestaurantFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String address;
  @override
  final String description;
  @override
  @JsonKey(name: 'opening_hours')
  final String openingHours;
  @override
  @JsonKey(name: 'telephone_number')
  final String telephoneNumber;
  @override
  @JsonKey(name: 'reservation_advance_hours')
  final double reservationAdvanceHours;
  @override
  final String type;
  @override
  @JsonKey(name: 'primary_table_view')
  final String? primaryTableView;

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, address: $address, description: $description, openingHours: $openingHours, telephoneNumber: $telephoneNumber, reservationAdvanceHours: $reservationAdvanceHours, type: $type, primaryTableView: $primaryTableView)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Restaurant &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.address, address) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality()
                .equals(other.openingHours, openingHours) &&
            const DeepCollectionEquality()
                .equals(other.telephoneNumber, telephoneNumber) &&
            const DeepCollectionEquality().equals(
                other.reservationAdvanceHours, reservationAdvanceHours) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.primaryTableView, primaryTableView));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(address),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(openingHours),
      const DeepCollectionEquality().hash(telephoneNumber),
      const DeepCollectionEquality().hash(reservationAdvanceHours),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(primaryTableView));

  @JsonKey(ignore: true)
  @override
  _$RestaurantCopyWith<_Restaurant> get copyWith =>
      __$RestaurantCopyWithImpl<_Restaurant>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RestaurantToJson(this);
  }
}

abstract class _Restaurant implements Restaurant {
  factory _Restaurant(
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
          String? primaryTableView}) = _$_Restaurant;

  factory _Restaurant.fromJson(Map<String, dynamic> json) =
      _$_Restaurant.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get address;
  @override
  String get description;
  @override
  @JsonKey(name: 'opening_hours')
  String get openingHours;
  @override
  @JsonKey(name: 'telephone_number')
  String get telephoneNumber;
  @override
  @JsonKey(name: 'reservation_advance_hours')
  double get reservationAdvanceHours;
  @override
  String get type;
  @override
  @JsonKey(name: 'primary_table_view')
  String? get primaryTableView;
  @override
  @JsonKey(ignore: true)
  _$RestaurantCopyWith<_Restaurant> get copyWith =>
      throw _privateConstructorUsedError;
}
