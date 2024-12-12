part of 'home_page_bloc.dart';

@immutable
sealed class PageNotification {}

@freezed
class ErrorNotification with _$ErrorNotification implements PageNotification {
  const factory ErrorNotification(Failure error) = _ErrorNotification;
}