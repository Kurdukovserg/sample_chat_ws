import 'package:chat_sample_app/data_sources/local_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../core/env.dart';

abstract class WebSocketService {
  IO.Socket get socket;
  void reset();
  void dispose();
}

class WebSocketServiceImpl implements WebSocketService {
  WebSocketServiceImpl(this._authLocalDataSource) {
    _socket = IO.io(Env.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'rejectUnauthorized': false,
      'autoConnect': false,
    });
    reset();
  }

  final AuthLocalDataSource _authLocalDataSource;
  late final IO.Socket _socket;

  @override
  void reset() async {
    final tokenOrFail = _authLocalDataSource.readAccessToken();
    tokenOrFail.fold(
        left,
        (token) => {
              _socket.io.options.addAll({'authorization': "${token.token}"})
            });
    _socket.connect();
  }

  @override
  IO.Socket get socket => _socket;

  @override
  void dispose() {
    _socket.disconnect().dispose();
  }
}
