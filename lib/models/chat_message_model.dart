import 'package:chat_sample_app/dtos/chat_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessageModel extends ChatMessage with _$ChatMessageModel {
  ChatMessageModel._();

  factory ChatMessageModel({
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'uid') required String uid,
    @JsonKey(name: 'date') required int date,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);
}