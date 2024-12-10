import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifiable_mixin.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

abstract class NotifiableBloc<Event, State, Notification>
    extends Bloc<Event, State> with NotifiableMixin<Notification> {
  NotifiableBloc(super.initialState);

  bool _closed = false;

  final Map<int, StreamSubscription> _dataSubscriptions = {};

  @override
  Future<void> close() async {
    _closed = true;
   await _closeAllDataSubs();
    return super.close();
  }

  Future<void> _closeAllDataSubs() async {
    await Future.wait(_dataSubscriptions.values.map((sub) => sub.cancel()));
  }

  Future<void> unregisterAllStreams() {
    return _closeAllDataSubs();
  }

  Future<void> registerStream<T>(
    Stream<T> stream,
    State? Function(T) map,
  ) async {
    final key = stream.hashCode;
    StreamSubscription? sub = _dataSubscriptions[key];

    if (sub != null) {
      await sub.cancel();
      sub = null;
      _dataSubscriptions.remove(key);
    }

    sub = stream.listen(
      (data) {
        if (!_closed) {
          final newState = map(data);
          if (newState != null) {
            // ignore: invalid_use_of_visible_for_testing_member
            emit(newState);
          }
        }
      },
    );
    _dataSubscriptions[key] = sub;
  }
}
