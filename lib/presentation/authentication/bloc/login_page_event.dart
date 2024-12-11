part of 'login_page_bloc.dart';

@immutable
sealed class PageEvent {}

@freezed
class LogIn with _$LogIn implements PageEvent {
  const factory LogIn(String username) = _LogIn;
}