import 'dart:async';

import 'package:chat_sample_app/dtos/access_token.dart';
import 'package:chat_sample_app/dtos/chat_notification.dart';
import 'package:chat_sample_app/repositories/auth_repository.dart';
import 'package:chat_sample_app/use_cases/getChatUpdates.dart';
import 'package:chat_sample_app/use_cases/sendMessage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';

import '../../../core/bloc/notifiable_bloc.dart';
import '../../../core/failures/failure.dart';
import '../../../dtos/chat_message.dart';

part 'home_page_bloc.freezed.dart';

part 'home_page_event.dart';

part 'home_page_notification.dart';

part 'home_page_state.dart';

@injectable
class HomePageBloc
    extends NotifiableBloc<PageEvent, PageBlocState, PageNotification> {
  HomePageBloc(this._getChatUpdates, this._authRepository, this._sendMessage)
      : super(const InitialState()) {
    on<Init>(_onInit);
    on<SendMessage>(_onSendMessage);
  }

  final GetChatUpdatesUseCase _getChatUpdates;
  final SendMessageUseCase _sendMessage;
  final AuthRepository _authRepository;

  List<ChatNotification> _notifications = [];
  AccessToken? _actualToken;

  PageBlocState get _updatedState =>
      UpdatedState(chatNotifications: _notifications);

  FutureOr<void> _onInit(Init event, Emitter<PageBlocState> emit) async {
    emit(LoadingState());
    await unregisterAllStreams();
    final chatUpdatesStreamOrFail = await _getChatUpdates();
    _actualToken = _authRepository.accessToken;
    final uid = _actualToken?.uid;
    logInfo('Uid = $uid');
    chatUpdatesStreamOrFail.fold(
        (failure) => emitNotification(ErrorNotification(Failure())), (stream) {
      registerStream(stream, (messages) {

        final mappedMessages = messages
            .map((element) => ChatNotificationDto(
                message: element.message,
                date: element.date,
                user: element.user,
                type: (element.user?.uid == uid)
                    ? (element.user!.userName.isNotEmpty)
                        ? NotificationType.my
                        : NotificationType.forMe
                    : element.type))
            .toList();
        _notifications = mappedMessages;

        return _updatedState;
      });
    });
    emit(_updatedState);
  }

  FutureOr<void> _onSendMessage(
      SendMessage event, Emitter<PageBlocState> emit) {
    final message = ChatMessageDto(
        message: event.message,
        uid: _actualToken!.uid,
        date: DateTime.now().millisecondsSinceEpoch);
    final sendOrFailure = _sendMessage.call(message);
    sendOrFailure
        .fold((failure) => emitNotification(ErrorNotification(failure)), (_) {
      //nothing - chat have to refresh
    });
  }
}
