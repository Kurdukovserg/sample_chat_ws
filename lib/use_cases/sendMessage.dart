import 'package:chat_sample_app/dtos/chat_message.dart';
import 'package:chat_sample_app/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../core/failures/failure.dart';
import '../core/use_case/use_case.dart';

abstract class SendMessageUseCase
    implements UseCase<Unit, ChatMessage> {
  @override
  Either<Failure, Unit> call(ChatMessage message);
}

@Injectable(as: SendMessageUseCase)
class GetChatUpdatesUseCaseImpl implements SendMessageUseCase {
  GetChatUpdatesUseCaseImpl(
      this._repository,
      );

  final ChatRepository _repository;

  @override
  Either<Failure, Unit> call(ChatMessage message)  {
    return _repository.sendMessage(message);
  }
}