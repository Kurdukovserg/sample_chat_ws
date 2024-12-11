import 'package:dartz/dartz.dart';

import '../core/failures/failure.dart';

abstract class ChatRepository {
  Future<Either<Failure, Unit>> connect();
  Future<Either<Failure, Unit>> dispose();

}