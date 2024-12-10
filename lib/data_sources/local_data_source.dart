import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/data_sources/failures.dart';
import '../core/failures/failure.dart';
import '../dtos/access_token.dart';
import 'failures.dart';

abstract class AuthLocalDataSource {
  bool get isAuthenticated;

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, Unit>> saveAccessToken(AccessToken accessToken);

  Either<Failure, AccessToken> readAccessToken();
}

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final SharedPreferences _storage;

  @override
  bool get isAuthenticated {
    final accessToken = readAccessToken();

    return accessToken.fold(
      (_) => false,
      (token) => true,
    );
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    final cleared = await _storage.clear();

    if (!cleared) {
      return left(const ClearStorageFailure());
    }

    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> saveAccessToken(
    AccessToken accessToken,
  ) async {
    final json = accessToken.toDto().toJson();
    final data = jsonEncode(json);

    final saved = await _storage.setString('access-token', data);

    if (!saved) {
      return left(const SaveDataFailure());
    }

    return right(unit);
  }

  @override
  Either<Failure, AccessToken> readAccessToken() {
    final data = _storage.getString('access-token');

    if (data == null) {
      return left(const ReadDataFailure());
    }

    final json = jsonDecode(data);
    final accessToken = AccessTokenDto.fromJson(json);

    return right(accessToken);
  }
}
