part of 'home_page_bloc.dart';

@immutable
sealed class PageEvent {}

@freezed
class Init with _$Init implements PageEvent {
  const factory Init() = _Init;
}

@freezed
class SendMessage with _$SendMessage implements PageEvent {
  const factory SendMessage({required String message}) = _SendMessage;
}