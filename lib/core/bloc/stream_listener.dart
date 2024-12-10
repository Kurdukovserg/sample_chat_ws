import 'dart:async';

import 'package:flutter/material.dart';

typedef OnStreamData<T> = void Function(T data);

class StreamListener<T> extends StatefulWidget {
  const StreamListener({
    required this.stream,
    required this.onData,
    required this.child,
    super.key,
  });

  final Stream<T> stream;
  final OnStreamData<T> onData;
  final Widget child;

  @override
  State<StreamListener<dynamic>> createState() => _StreamListenerState<T>();
}

class _StreamListenerState<T> extends State<StreamListener<T>> {
  late StreamSubscription<T> _streamSubscription;

  @override
  void initState() {
    super.initState();

    _streamSubscription = widget.stream.listen(widget.onData);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
