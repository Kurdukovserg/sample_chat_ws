part of 'home_page_bloc.dart';

@immutable
sealed class PageEvent {}

@freezed
class Init with _$Init implements PageEvent {
  const factory Init() = _Init;
}