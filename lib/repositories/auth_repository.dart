import 'package:chat_sample_app/dtos/access_token.dart';
import 'package:chat_sample_app/models/login_request.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../core/failures/failure.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';
import '../services/network_sevice.dart';

abstract class AuthRepository {
  Future<Either<Failure, AccessToken>> login(String username);

  Future<Either<Failure, Unit>> saveAccessToken(AccessToken accessToken);
}

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._local,
    this._remote,
    this._httpClientsService,
  );

  final AuthLocalDataSource _local;
  final AuthRemoteDataSource _remote;
  final HttpClientsService _httpClientsService;

  @override
  Future<Either<Failure, AccessToken>> login(String username) {
    return _remote.login(LoginRequest(username: username));
  }

  @override
  Future<Either<Failure, Unit>> saveAccessToken(AccessToken accessToken) async {
    final savedOrFailure = await _local.saveAccessToken(accessToken);
    savedOrFailure.map((_) async {
      _httpClientsService.reset();
    });
    return savedOrFailure;
  }
}
