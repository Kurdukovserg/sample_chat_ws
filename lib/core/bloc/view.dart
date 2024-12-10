import 'package:flutter/material.dart' hide NotificationListener;

import '../injection/injection.dart';
import 'notifiable_bloc.dart';
import 'notifiable_bloc_builder.dart';

class BaseView<Bloc extends NotifiableBloc<Event, ViewState, Notification>,
    Event, ViewState, Notification> extends StatefulWidget {
  const BaseView({
    super.key,
    this.initialEvent,
    this.onBlocUpdated,
    required this.onNotification,
    this.buildWhen,
    required this.builder,
  });

  final BlocWidgetBuilder<ViewState> builder;
  final NotificationListener<Notification> onNotification;
  final BlocBuilderCondition<ViewState>? buildWhen;
  final Event? initialEvent;
  final ValueChanged<Bloc>? onBlocUpdated;

  @override
  State<BaseView<Bloc, Event, ViewState, Notification>> createState() =>
      _BaseViewState<Bloc, Event, ViewState, Notification>();
}

class _BaseViewState<
        Bloc extends NotifiableBloc<Event, ViewState, Notification>,
        Event,
        ViewState,
        Notification>
    extends State<BaseView<Bloc, Event, ViewState, Notification>> {
  late Bloc bloc;

  void _addInitialEvent() {
    if (widget.initialEvent != null) {
      bloc.add(widget.initialEvent as Event);
    }
  }

  @override
  void initState() {
    super.initState();
    bloc = sl();
    widget.onBlocUpdated?.call(bloc);
    _addInitialEvent();
  }

  @override
  void didUpdateWidget(
    covariant BaseView<Bloc, Event, ViewState, Notification> oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialEvent != oldWidget.initialEvent) {
      _addInitialEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<Bloc>(
      create: (context) => bloc,
      child: NotifiableBlocBuilder<Bloc, ViewState, Notification>(
        onNotification: widget.onNotification,
        builder: widget.builder,
        buildWhen: widget.buildWhen,
      ),
    );
  }
}
