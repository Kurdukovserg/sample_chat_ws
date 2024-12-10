import 'dart:async';

mixin NotifiableMixin<NotificationType> {
  final _notificationsController =
  StreamController<NotificationType>.broadcast();

  Stream<NotificationType> get notificationsStream {
    return _notificationsController.stream;
  }

  void emitNotification(NotificationType notification) {
    _notificationsController.add(notification);
  }
}