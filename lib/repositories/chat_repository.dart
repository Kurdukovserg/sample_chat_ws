import 'package:chat_sample_app/dtos/chat_message.dart';
import 'package:chat_sample_app/services/web_socket_service.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../core/failures/failure.dart';

abstract class ChatRepository {
  Future<Either<Failure, IO.Socket>> connect();

  Future<Either<Failure, Unit>> dispose();

  Stream<List<ChatMessage>> get messages;

  Future<Either<Failure, Unit>> sendMessage(ChatMessage message);
}

@Singleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(
    this._webSocketService,
  );

  final WebSocketService _webSocketService;

  late final BehaviorSubject<List<ChatMessage>> _messagesController =
      BehaviorSubject<List<ChatMessage>>(
    onListen: _onMessagesListen,
    onCancel: _onCancelMessagesSubscription,
  );

  List<ChatMessage>? _cachedMessagesVal;

  List<ChatMessage>? get _cachedMessages => _cachedMessagesVal;

  set _cachedMessages(List<ChatMessage>? newMessages) {
    _cachedMessagesVal = newMessages;
    if (newMessages != null) {
      _messagesController.add(newMessages);
    }
  }

  void _onMessagesListen() async {
    final socketOrFail = await _webSocketService.init();
    socketOrFail.fold((fail) => logError(fail), (socket) {
      logInfo('socket connection status: ${socket.connected}');
      socket.on('connect', (_) {
        logInfo('connected, data: ${socket.id}');
        socket.on('message', (message) {
          logInfo('message received: $message');
          convertAndSink(message);
        });
      });
    });
  }

  void _onCancelMessagesSubscription() {
    dispose();
  }

  @override
  Future<Either<Failure, IO.Socket>> connect() async {
    logInfo('connect');
    try {
      final socketOrNull = _webSocketService.socket;
      if (socketOrNull != null && socketOrNull.connected) {
        return right(_webSocketService.socket!);
      }
      return _webSocketService.init();
    } catch (e) {
      return left(Failure());
    }
  }

  @override
  Future<Either<Failure, Unit>> dispose() async {
    try {
      _webSocketService.dispose();
      return right(unit);
    } catch (e) {
      return left(Failure());
    }
  }

  @override
  Stream<List<ChatMessage>> get messages => _messagesController.stream;

  @override
  Future<Either<Failure, Unit>> sendMessage(ChatMessage message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  void convertAndSink(message) {
    final newMessage = ChatMessageDto.fromJson(message);
    final newMessages = _cachedMessages;
    newMessages?.add(newMessage);
    _cachedMessages = newMessages;
  }
}
