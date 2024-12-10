import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final sl = GetIt.instance;

@injectableInit
Future<GetIt> initSl() async => sl.init();

@module
abstract class RegisterModule {

  @singleton
  Dio dio() {
    final dio = Dio();

    dio.interceptors.add(LogInterceptor());
    dio.options.contentType = Headers.jsonContentType;

    return dio;
  }
}