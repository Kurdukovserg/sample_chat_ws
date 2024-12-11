import 'package:chat_sample_app/dtos/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel extends User with _$UserModel {
  UserModel._();

  factory UserModel({
    @JsonKey(name: 'userName') required String userName,
    @JsonKey(name: 'uid') required String uid,

  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}