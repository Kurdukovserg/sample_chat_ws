import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class HttpClientsService {
  Dio get apiClient;

  void reset();
}

@Singleton(as: HttpClientsService)
class HttpClientsServiceImpl implements HttpClientsService {
  HttpClientsServiceImpl() {
    _apiClient = Dio();
    reset();
  }


  late final Dio _apiClient;

  @override
  void reset() {
    _apiClient.options.contentType = Headers.jsonContentType;
    _apiClient.options.headers['Accept'] = 'application/json';
    _apiClient.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  @override
  Dio get apiClient => _apiClient;
}