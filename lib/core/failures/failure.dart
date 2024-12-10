import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

class Failure {
  const Failure();
}

@freezed
class NetworkFailure extends Failure with _$NetworkFailure {
  const NetworkFailure._();

  const factory NetworkFailure({
    int? code,
    String? message,
  }) = _NetworkFailure;
}