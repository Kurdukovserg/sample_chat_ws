import 'package:auto_route/auto_route.dart';
import 'package:chat_sample_app/core/bloc/notifiable_bloc.dart';
import 'package:chat_sample_app/core/routing/router.dart';
import 'package:chat_sample_app/gen/assets.gen.dart';
import 'package:chat_sample_app/presentation/components/neumorfism_button.dart';
import 'package:chat_sample_app/presentation/components/neumorfism_container.dart';
import 'package:chat_sample_app/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

import '../../core/bloc/view.dart';
import '../../core/components/spacing.dart';
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
      body: Stack(children: [
        Assets.images.peakpx.image(
            fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height),
        Padding(
          padding: MediaQuery.paddingOf(context)
              .add(EdgeInsets.symmetric(horizontal: 16.0)),
          child: BaseView<LoginPageBloc, PageEvent, PageBlocState,
              PageNotification>(
            onNotification:
                (BuildContext context, PageNotification notification) {
              switch (notification) {
                case LoggedIn():
                  logInfo('Logged in!');
                  context.pushRoute(HomeRoute());
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
                UpdatedState() => Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Please enter your name',
                            style: Theme.of(context).textTheme.headlineMedium),
                        S.s4(),
                        NeumorfismContainer(
                          radius: 12,
                          isInset: true,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.perm_identity,
                                  ),
                                  border: InputBorder.none),
                              validator: (value) =>
                                  Validate.usernameIsNotEmpty(value),
                              controller: _usernameController,
                            ),
                          ),
                        ),
                        S.s16(),
                        NeumorfismButton(
                          radius: 12,
                          onPress: () =>_onLogIn(context),
                          child: SizedBox(
                            width: 200,
                            height: 50,
                            child: Center(child: Text('Login')),
                          ),
                        ),
                        S.s24(),
                      ],
                    ))
              };
            },
          ),
        ),
      ]),
    );
  }

  void _onLogIn(BuildContext context) {
    _form.validate()
        ? context.read<LoginPageBloc>().add(LogIn(_usernameController.text))
        : null;
  }
}
