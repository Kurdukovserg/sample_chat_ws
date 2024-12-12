import 'dart:async';

import 'package:chat_sample_app/dtos/chat_message.dart';
import 'package:chat_sample_app/dtos/chat_notification.dart';
import 'package:chat_sample_app/use_cases/getChatUpdates.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';

import '../../../core/bloc/notifiable_bloc.dart';
import '../../../core/failures/failure.dart';

part 'home_page_bloc.freezed.dart';
part 'home_page_event.dart';
part 'home_page_notification.dart';
part 'home_page_state.dart';

@injectable
class HomePageBloc
    extends NotifiableBloc<PageEvent, PageBlocState, PageNotification> {
  HomePageBloc(this._getChatUpdates) : super(const InitialState()) {
    on<Init>(_onInit);
  }

  final GetChatUpdatesUseCase _getChatUpdates;

  List<ChatNotification> _notifications = [];

  PageBlocState get _updatedState => UpdatedState(chatNotifications: _notifications!);

  FutureOr<void> _onInit(Init event, Emitter<PageBlocState> emit) async {
    emit(LoadingState());
    await unregisterAllStreams();
    final chatUpdatesStreamOrFail = await _getChatUpdates();
    chatUpdatesStreamOrFail
        .fold((failure) => emitNotification(ErrorNotification(Failure())), (stream) {
      registerStream(stream, (messages) {
        logInfo(messages);
        _notifications = messages;
        return _updatedState;
      });
    });
    emit(_updatedState);
  }
}
