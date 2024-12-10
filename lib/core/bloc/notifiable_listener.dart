import 'package:flutter/material.dart';

import 'notifiable_mixin.dart';
import 'stream_listener.dart';

class NotifiableListener<Data> extends StatelessWidget {
  const NotifiableListener({
    required this.notifiable,
    required this.onNotification,
    required this.child,
    super.key,
  });

  final NotifiableMixin<Data> notifiable;
  final OnStreamData<Data> onNotification;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamListener(
      stream: notifiable.notificationsStream,
      onData: onNotification,
      child: child,
    );
  }
}