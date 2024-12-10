import 'package:flutter/material.dart';

import 'notifiable_bloc.dart';
import 'view.dart';

abstract class PageState<
    T extends StatefulWidget,
    Bloc extends NotifiableBloc<Event, ViewState, Notification>,
    Event,
    ViewState,
    Notification> extends State<T> {
  Bloc? _bloc;

  Bloc get bloc => _bloc!;

  Event? get initialEvent => null;

  @override
  Widget build(BuildContext context) {
    return BaseView<Bloc, Event, ViewState, Notification>(
      initialEvent: initialEvent,
      builder: buildPage,
      onNotification: onNotification,
      onBlocUpdated: (bloc) => _bloc = bloc,
    );
  }

  void reInitBloc() {
    if (initialEvent != null) {
      // ignore: null_check_on_nullable_type_parameter
      bloc.add(initialEvent!);
    }
  }

  void onNotification(BuildContext context, Notification notification);

  Widget buildPage(BuildContext context, ViewState state);
}
