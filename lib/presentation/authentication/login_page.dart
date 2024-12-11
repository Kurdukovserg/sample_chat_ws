import 'package:auto_route/auto_route.dart';
import 'package:chat_sample_app/core/bloc/notifiable_bloc.dart';
import 'package:chat_sample_app/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

import '../../core/bloc/view.dart';
import 'bloc/login_page_bloc.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FormState get _form => _formKey.currentState!;

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
                logInfo('Logged in!');
              case ErrorNotification():
                logError('login error: ${notification.error}');
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
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) =>
                                  Validate.usernameIsNotEmpty(value),
                              controller: _usernameController,
                            ),
                            MaterialButton(
                              onPressed: () {
                                context
                                    .read<LoginPageBloc>()
                                    .add(LogIn(_usernameController.text));
                              },
                              child: Text('data'),
                            )
                          ],
                        )),
                  ],
                )
            };
          },
        ),
      ),
    );
  }
}
