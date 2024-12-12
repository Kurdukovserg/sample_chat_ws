import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

abstract class ChatMessage {
  const ChatMessage();

  String get message;
  String get uid;
  int get date;

  ChatMessageDto toDto() {
    return ChatMessageDto(
      message: message,
      uid:uid,
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
    required int date,
  }) = _ChatMessageDto;

  @override
  ChatMessageDto toDto() => this;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);
}