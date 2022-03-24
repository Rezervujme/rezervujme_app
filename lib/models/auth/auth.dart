import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

@freezed
class Auth with _$Auth {
  factory Auth({required String? token, required User? user}) = _Auth;

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
}

@freezed
class User with _$User {
  factory User({
    required int id,
    required String name,
    required String surname,
    required String username,
    required String email,
    required dynamic avatar,
    required dynamic permissions,
    @JsonKey(name: 'last_login') required DateTime? lastLogin,
    @JsonKey(name: 'last_seen') required DateTime? lastSeen,
    @JsonKey(name: 'activated_at') required DateTime activatedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') required DateTime? deletedAt,
    @JsonKey(name: 'is_activated') required bool isActivated,
    @JsonKey(name: 'is_guest') required int? isGuest,
    @JsonKey(name: 'is_superuser') required int? isSuperuser,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
