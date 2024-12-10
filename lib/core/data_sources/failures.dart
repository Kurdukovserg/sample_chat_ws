import '../failures/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class ReadDataFailure extends Failure with _$ReadDataFailure {
  const factory ReadDataFailure() = _ReadDataFailure;
}

@freezed
class SaveDataFailure extends Failure with _$SaveDataFailure {
  const factory SaveDataFailure() = _SaveDataFailure;
}
