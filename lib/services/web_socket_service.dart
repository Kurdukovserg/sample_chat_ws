import 'dart:io';

import 'package:chat_sample_app/data_sources/local_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../core/env.dart';
import '../core/failures/failure.dart';

abstract class WebSocketService {
  IO.Socket? get socket;

  Future<Either<Failure, IO.Socket>> init();

  void dispose();
}

@Singleton(as: WebSocketService)
class WebSocketServiceImpl implements WebSocketService {
  WebSocketServiceImpl(this._authLocal);

  IO.Socket? _socket;
  final AuthLocalDataSource _authLocal;

  @override
  Future<Either<Failure, IO.Socket>> init() async {
    final token = _authLocal.readAccessToken();
    return token.fold(left, (token) {
      _socket = IO.io(
          Env.socketUrl,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .setExtraHeaders(
                  {HttpHeaders.authorizationHeader: 'bearer ${token.token}'})
              .disableAutoConnect()
              .setReconnectionAttempts(5)
              .build());
      _socket?.io.options?.update(
          'extraHeaders',
          (value) =>
              {HttpHeaders.authorizationHeader: 'bearer ${token.token}'});

      logInfo(_socket?.io.options);

      logInfo('connecting to socket on ${Env.socketUrl}');
      _socket?.on('connecting', (_) {
        logInfo('Connecting, user: ${token.uid}');
      });
      _socket?.onConnectError((error) {
        logError('Connecting error, data: $error');
      });
      _socket?.onReconnectError((message) {
        logError('Connecting time out, data: $message');
      });
      _socket?.onConnect((_) {
        logInfo('Connected user: ${token.uid}');
      });
      _socket?.onError((_) {
        logError('Socket error');
      });
      _socket?.on('error', (data) {
        logError('socket error: $data');
      });
      _socket?.onPing((_) => logInfo('Ping received from server'));
      _socket?.onPong((_) => logInfo('Pong sent to server'));
      _socket?.onReconnect((_) => logInfo('Reconnected'));
      _socket?.onReconnectAttempt((_) => logInfo('Reconnecting...'));
      _socket?.onDisconnect((_) => dispose());
      _socket?.connect();
      return right(_socket!);
    });
  }

  @override
  IO.Socket? get socket => _socket;

  @override
  void dispose() {
    logInfo('Disconnecting');
    _socket?.dispose();
    _socket?.destroy();
    _socket?.io.close();
    _socket = null;
  }
}
