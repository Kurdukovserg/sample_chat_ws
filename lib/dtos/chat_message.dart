import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

abstract class ChatMessage {
  const ChatMessage();

  String get message;
  String get uid;
  String get userName;
  String get date;

  ChatMessageDto toDto() {
    return ChatMessageDto(
      message: message,
      uid:uid,
      userName: userName,
      date: date
    );
  }
}

@freezed
class ChatMessageDto extends ChatMessage with _$ChatMessageDto {
  const ChatMessageDto._();

  const factory ChatMessageDto({
    required String message,
    required String uid,
    required String userName,
    required String date,
  }) = _ChatMessageDto;

  @override
  ChatMessageDto toDto() => this;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);
}