import 'package:chat_sample_app/models/access_token_model.dart';
import 'package:chat_sample_app/models/login_request.dart';
import 'package:chat_sample_app/services/api.dart';
import 'package:chat_sample_app/services/error_handlers.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/failures/failure.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, AccessTokenModel>> login(LoginRequest request);
}

@Injectable(as: AuthRemoteDataSource)
class ConfigRemoteDataSourceImpl implements AuthRemoteDataSource {
  ConfigRemoteDataSourceImpl(
    this._api,
  );

  final ExampleChatApiService _api;

  @override
  Future<Either<Failure, AccessTokenModel>> login(LoginRequest request) {
    return _api
        .login(loginRequest: request)
        .then((token) =>
            right<Failure, AccessTokenModel>(AccessTokenModel(token: token)))
        .onNetworkError();
  }
}
