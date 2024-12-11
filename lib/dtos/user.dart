import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

abstract class User {
  const User();

  String get userName;

  String get uid;

  UserDto toDto() {
    return UserDto(
      userName: userName,
      uid: uid,
    );
  }
}

@freezed
class UserDto extends User with _$UserDto {
  const UserDto._();

  const factory UserDto({
    required String userName,
    required String uid,
  }) = _UserDto;

  @override
  UserDto toDto() => this;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
