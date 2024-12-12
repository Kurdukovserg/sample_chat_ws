import 'package:chat_sample_app/dtos/chat_message.dart';
import 'package:chat_sample_app/dtos/chat_notification.dart';
import 'package:chat_sample_app/models/chat_notification_model.dart';
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

  Stream<List<ChatNotification>> get chatNotifications;

  Either<Failure, Unit> sendMessage(ChatMessage message);
}

@Singleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(
    this._webSocketService,
  );

  final WebSocketService _webSocketService;

  late final BehaviorSubject<List<ChatNotification>> _notificationsController =
      BehaviorSubject<List<ChatNotification>>(
    onListen: _onNotificationsListen,
    onCancel: _onCancelNotificationsSubscription,
  );

  List<ChatNotification>? _cachedNotificationsVal;

  List<ChatNotification>? get _cachedNotifications => _cachedNotificationsVal;

  set _cachedNotifications(List<ChatNotification>? newNotifications) {
    _cachedNotificationsVal = newNotifications;
    if (newNotifications != null) {
      _notificationsController.add(newNotifications);
    }
  }

  void _onNotificationsListen() async {
    final socketOrFail = await _webSocketService.init();
    socketOrFail.fold((fail) => logError(fail), (socket) {
      logInfo('socket connection status: ${socket.connected}');
      socket.on('connect', (_) {
        logInfo('connected, data: ${socket.id}');
        socket.on('message', (message) {
          logInfo('message received: $message');
          convertAndSink(message);
        });
        socket.on('notification', (notification) {
          logInfo('notification received: $notification');
          convertAndSink(notification);
        });
      });
    });
  }

  void _onCancelNotificationsSubscription() {
    dispose();
  }

  @override
  Future<Either<Failure, IO.Socket>> connect() async {
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
  Stream<List<ChatNotification>> get chatNotifications =>
      _notificationsController.stream;

  @override
  Either<Failure, Unit> sendMessage(ChatMessage message) {
    logInfo('sending message: $message');
    final socket = _webSocketService.socket;
    try {
      socket!.emit('message', message.toDto().toJson());
    } catch (e) {
      return left(Failure());
    }
    return right(unit);
  }

  void convertAndSink(message) {
    final newNotificationModel = ChatNotificationModel.fromJson(message);
    final newNotification = ChatNotificationDto.fromModel(newNotificationModel);

    List<ChatNotification> newNotifications = [...?_cachedNotifications];
    newNotifications.add(newNotification);
    _cachedNotifications = newNotifications;
  }
}
