
import 'package:chat_sample_app/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'chat_notification_model.freezed.dart';
part 'chat_notification_model.g.dart';

@freezed
class ChatNotificationModel with _$ChatNotificationModel {
  ChatNotificationModel._();

  factory ChatNotificationModel({
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'date') required int date,
    @JsonKey(name: 'user') UserModel? user,
  }) = _ChatNotificationModel;

  factory ChatNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$ChatNotificationModelFromJson(json);
}