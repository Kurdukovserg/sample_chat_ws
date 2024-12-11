import 'dart:io';
import 'dart:typed_data';

import 'package:chat_sample_app/data_sources/local_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


import '../core/env.dart';

abstract class WebSocketService {
  IO.Socket get socket;

  void init();

  void dispose();
}

@Singleton(as: WebSocketService)
class WebSocketServiceImpl implements WebSocketService {
  WebSocketServiceImpl(this._authLocalDataSource);

  final AuthLocalDataSource _authLocalDataSource;
  IO.Socket? _socket;
  final Map<String, dynamic> extra = {};

  @override
  void init() async {
    final tokenOrFail = _authLocalDataSource.readAccessToken();
    tokenOrFail.fold(left, (token) {
      _socket = IO.io(Env.socketUrl,
          IO.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM// disable auto-connection
              .setExtraHeaders({HttpHeaders.authorizationHeader: 'bearer ${token.token}'}) // optional
              .build()
      );
    });
    _socket?.onConnect((_) {
      logInfo('Connected');
    });
    _socket?.onError((_) {
      logError('Socket error');
    });
    _socket?.on('error', (data) {
      logError('socket error: $data');
    });
    _socket?.connect();

    final socket = await Socket.connect("0.0.0.0", 3000);
    print('Server: Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
    socket.listen((Uint8List data) {
      logInfo('data received: ${String.fromCharCodes(data)}');
    });
  }

  @override
  IO.Socket get socket => _socket!;

  @override
  void dispose() {
    _socket?.disconnect().dispose();
  }
}
