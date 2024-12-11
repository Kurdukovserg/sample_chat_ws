import 'package:chat_sample_app/models/access_token_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/error_logger.dart';

import '../core/env.dart';
import '../models/login_request.dart';
import 'network_sevice.dart';

part 'api.g.dart';

@injectable
@RestApi()
abstract class ExampleChatApiService {
  @factoryMethod
  factory ExampleChatApiService(HttpClientsService clientService) =>
      _ExampleChatApiService(
        clientService.apiClient,
          baseUrl: Env.apiUrl
      );

  @GET('self')
  Future<String> getSelf();

  @POST('login')
  Future<AccessTokenModel> login({
    @Body() required LoginRequest loginRequest,
  });
}