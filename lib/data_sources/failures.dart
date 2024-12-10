import '../core/failures/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class ClearStorageFailure extends Failure with _$ClearStorageFailure {
  const factory ClearStorageFailure() = _ClearStorageFailure;
}
