import 'dart:async';

import 'package:chat_sample_app/core/failures/failure.dart';
import 'package:chat_sample_app/models/login_request.dart';
import 'package:chat_sample_app/use_cases/login.dart';
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
  LoginPageBloc(
    this._login,
  ) : super(const UpdatedState()) {
    on<LogIn>(_onLogIn);
  }

  final LoginUseCase _login;

  FutureOr<void> _onLogIn(LogIn event, Emitter<PageBlocState> emit) async {
    emit(LoadingState());
    final loginOrFailure = await _login(
      LoginRequest(
        username: event.username,
      ),
    );
    loginOrFailure.fold(
        (failure) => emitNotification(ErrorNotification(failure)),
        (_) => emitNotification(LoggedIn()));
    emit(UpdatedState());
  }
}
