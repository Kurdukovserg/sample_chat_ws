import 'package:freezed_annotation/freezed_annotation.dart';

part 'access_token.freezed.dart';
part 'access_token.g.dart';

abstract class AccessToken {
  const AccessToken();

  String get token;
  String get uid;

  AccessTokenDto toDto() {
    return AccessTokenDto(
      token: token,
      uid: uid,
    );
  }
}

@freezed
class AccessTokenDto extends AccessToken with _$AccessTokenDto {
  const AccessTokenDto._();

  const factory AccessTokenDto({
    required String token,
    required String uid,
  }) = _AccessTokenDto;

  @override
  AccessTokenDto toDto() => this;

  factory AccessTokenDto.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenDtoFromJson(json);
}
