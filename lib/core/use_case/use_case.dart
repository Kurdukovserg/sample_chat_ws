import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../failures/failure.dart';

abstract class UseCase<Type, Params> {
  FutureOr<Either<Failure, Type>> call(Params params);
}

@immutable
class NoParams {
  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    if (Object is NoParams) return true;

    return false;
  }
}
