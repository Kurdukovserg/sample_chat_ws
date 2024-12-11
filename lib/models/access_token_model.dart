// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../dtos/access_token.dart';

part 'access_token_model.freezed.dart';
part 'access_token_model.g.dart';

@freezed
class AccessTokenModel extends AccessToken with _$AccessTokenModel {
  AccessTokenModel._();

  factory AccessTokenModel({
    @JsonKey(name: 'token') required String token,
    @JsonKey(name: 'uid') required String uid,
  }) = _AccessTokenModel;

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenModelFromJson(json);
}
