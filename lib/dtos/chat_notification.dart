import 'package:chat_sample_app/models/chat_notification_model.dart';
import 'package:chat_sample_app/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_notification.freezed.dart';
part 'chat_notification.g.dart';

enum NotificationType {
  server,
  user,
  my,
  forMe,
}

abstract class ChatNotification {
  const ChatNotification();

  String get message;

  int get date;

  UserModel? get user;

  NotificationType get type;

  DateTime get localDate => DateTime.fromMillisecondsSinceEpoch(date).toLocal();

  ChatNotificationDto toDto() {
    return ChatNotificationDto(
      message: message,
      date: date,
      user: user,
      type: type,
    );
  }
}

@freezed
class ChatNotificationDto extends ChatNotification with _$ChatNotificationDto {
  const ChatNotificationDto._();

  const factory ChatNotificationDto({
    required String message,
    required int date,
    UserModel? user,
    required NotificationType type,
  }) = _ChatNotificationDto;

  @override
  ChatNotificationDto toDto() => this;

  factory ChatNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$ChatNotificationDtoFromJson(json);

  factory ChatNotificationDto.fromModel(ChatNotificationModel model) {
    return ChatNotificationDto(
      message: model.message,
      date: model.date,
      type: (model.user == null)
          ? NotificationType.server
          : NotificationType.user,
      user: (model.uid != null)
          ? UserModel(userName: '', uid: model.uid!)
          : model.user,
    );
  }
}
