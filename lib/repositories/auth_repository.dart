import 'package:chat_sample_app/dtos/access_token.dart';
import 'package:chat_sample_app/models/login_request.dart';
import 'package:chat_sample_app/services/web_socket_service.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../core/failures/failure.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';
import '../services/network_sevice.dart';

abstract class AuthRepository {
  Future<Either<Failure, AccessToken>> login(String username);

  Future<Either<Failure, Unit>> saveAccessToken(AccessToken accessToken);

  AccessToken? get accessToken;
}

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._local,
    this._remote,
    this._httpClientsService,
    this._webSocketService,
  );

  final AuthLocalDataSource _local;
  final AuthRemoteDataSource _remote;
  final HttpClientsService _httpClientsService;
  final WebSocketService _webSocketService;
  AccessToken? _accessToken;

  @override
  Future<Either<Failure, AccessToken>> login(String username) {
    return _remote.login(LoginRequest(username: username));
  }

  @override
  Future<Either<Failure, Unit>> saveAccessToken(AccessToken accessToken) async {
    _accessToken = accessToken;
    final savedOrFailure = await _local.saveAccessToken(accessToken);
    savedOrFailure.map((_) async {
      _httpClientsService.reset();
      _webSocketService.dispose();
    });
    return savedOrFailure;
  }

  @override
  AccessToken? get accessToken {
    if (_accessToken != null) {
      return _accessToken!;
    }
    return _local.readAccessToken().fold((_) => null, (token) => token);
  }
}
