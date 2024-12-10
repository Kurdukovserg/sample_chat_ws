import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/bloc/view.dart';
import 'bloc/login_page_bloc.dart';


@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MediaQuery.paddingOf(context)
            .add(EdgeInsets.symmetric(horizontal: 16.0)),
        child:
        BaseView<LoginPageBloc, PageEvent, PageBlocState, PageNotification>(
          onNotification:
              (BuildContext context, PageNotification notification) {
            switch (notification) {
              case LoggedIn():
                // TODO: Handle this case.
            }
          },
          builder: (BuildContext context, PageBlocState state) {
            return switch (state) {
              LoadingState() => Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
              ErrorState() => Center(
                child: Text(state.errorMessage),
              ),
              UpdatedState() => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text('Hello'),

                  ),
                ],
              )
            };
          },
        ),
      ),
    );
  }
}
