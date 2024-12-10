import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/bloc/notifiable_bloc.dart';

part 'home_page_bloc.freezed.dart';
part 'home_page_event.dart';
part 'home_page_notification.dart';
part 'home_page_state.dart';

@injectable
class HomePageBloc
    extends NotifiableBloc<PageEvent, PageBlocState, PageNotification> {
  HomePageBloc() : super(const UpdatedState()) {

  }

}
