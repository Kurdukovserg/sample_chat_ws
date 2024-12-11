part of 'login_page_bloc.dart';

@immutable
sealed class PageNotification {}

@freezed
class LoggedIn extends PageNotification with _$LoggedIn{
  const factory LoggedIn() = _LoggedIn;
}

@freezed
class ErrorNotification with _$ErrorNotification implements PageNotification {
  const factory ErrorNotification(Failure error) = _ErrorNotification;
}