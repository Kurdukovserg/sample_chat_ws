import 'package:chat_sample_app/constants/strings.dart';

abstract class Validate{
  static String? usernameIsNotEmpty(
      String? value,
      ) {
    if (value?.isEmpty ?? true) {
      return Strings.usernameIsEmpty;
    }
    return null;
  }
}