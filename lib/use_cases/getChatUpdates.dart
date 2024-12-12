import 'package:chat_sample_app/dtos/chat_notification.dart';
import 'package:chat_sample_app/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../core/failures/failure.dart';
import '../core/use_case/use_case.dart';

abstract class GetChatUpdatesUseCase
    implements UseCase<Stream<List<ChatNotification>>, NoParams> {
  @override
  Either<Failure, Stream<List<ChatNotification>>> call([NoParams? params]);
}

@Injectable(as: GetChatUpdatesUseCase)
class GetChatUpdatesUseCaseImpl implements GetChatUpdatesUseCase {
  GetChatUpdatesUseCaseImpl(
    this._repository,
  );

  final ChatRepository _repository;

  @override
  Either<Failure, Stream<List<ChatNotification>>> call([NoParams? params]) {
    return right(_repository.chatNotifications);
  }
}
