part of 'home_page_bloc.dart';

@immutable
sealed class PageBlocState {}

@freezed
class LoadingState with _$LoadingState implements PageBlocState {
  const factory LoadingState() = _LoadingState;
}

@freezed
class ErrorState with _$ErrorState implements PageBlocState {
  const factory ErrorState(String errorMessage) = _ErrorState;
}

@freezed
class UpdatedState with _$UpdatedState implements PageBlocState {
  const factory UpdatedState() = _UpdatedState;
}