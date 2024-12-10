import 'package:flutter/material.dart';

import 'notifiable_bloc.dart';
import 'notifiable_listener.dart';

typedef NotificationListener<Notification> = void Function(
    BuildContext context,
    Notification notification,
    );

class NotifiableBlocBuilder<
Bloc extends NotifiableBloc<Object?, State, Notification>,
State,
Notification> extends StatelessWidget {
  const NotifiableBlocBuilder({
    required this.onNotification,
    required this.builder,
    super.key,
    this.bloc,
    this.buildWhen,
  });

  final Bloc? bloc;
  final NotificationListener<Notification> onNotification;
  final BlocWidgetBuilder<State> builder;
  final BlocBuilderCondition<State>? buildWhen;

  @override
  Widget build(BuildContext context) {
    return NotifiableListener<Notification>(
      notifiable: bloc ?? context.read<Bloc>(),
      onNotification: (data) => onNotification(context, data),
      child: BlocBuilder(
        bloc: bloc,
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}