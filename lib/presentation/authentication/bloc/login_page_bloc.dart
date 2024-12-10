import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/bloc/notifiable_bloc.dart';

part 'login_page_bloc.freezed.dart';
part 'login_page_event.dart';
part 'login_page_notification.dart';
part 'login_page_state.dart';

@injectable
class LoginPageBloc
    extends NotifiableBloc<PageEvent, PageBlocState, PageNotification> {
  LoginPageBloc() : super(const UpdatedState()) {

  }

}
