import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../core/failures/failure.dart';

extension DioErrorHandler<L extends Failure, R> on Future<Either<Failure, R>> {
  Future<Either<Failure, R>> onNetworkError() {
    return onError<DioException>(
      (error, _) {
        return left(NetworkFailure(
            code: error.response?.statusCode,
            message: error.response?.statusMessage));
      },
    );
  }

  Future<Either<Failure, R>> onHttp400(Failure failure400) {
    return onHttpCode(400, failure400);
  }

  Future<Either<Failure, R>> onHttp404(Failure failure404) {
    return onHttpCode(404, failure404);
  }

  Future<Either<Failure, R>> onHttpCode(int code, Failure failure) {
    return onError<DioException>(
      (error, _) {
        if (error.response?.statusCode == code) {
          return left<Failure, R>(failure);
        }
        return left(NetworkFailure(
          code: error.response?.statusCode,
          message: error.message,
        ));
      },
    );
  }
}
