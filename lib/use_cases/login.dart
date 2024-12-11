import 'package:chat_sample_app/models/login_request.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../core/failures/failure.dart';
import '../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

abstract class LoginUseCase implements UseCase<Unit, LoginRequest> {
  @override
  Future<Either<Failure, Unit>> call(LoginRequest loginRequest);
}

@Injectable(as: LoginUseCase)
class LoginUseCaseImpl implements LoginUseCase {
  LoginUseCaseImpl(
      this._repository,
      );

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(LoginRequest params) async {
    final resOrFailure = await _repository.login(
      params.username
    );

    return resOrFailure.fold(left, (accessToken) async {
      final savedOrFailure =
      await _repository.saveAccessToken(accessToken);
      return savedOrFailure.map((_) {
        return unit;
      });
    });
  }
}