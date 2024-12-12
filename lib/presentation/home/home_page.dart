import 'package:auto_route/auto_route.dart';
import 'package:chat_sample_app/presentation/components/neumorfism_button.dart';
import 'package:chat_sample_app/presentation/components/neumorfism_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/bloc/view.dart';
import '../../core/components/spacing.dart';
import '../../gen/assets.gen.dart';
import 'bloc/home_page_bloc.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Assets.images.bgChat.image(
            fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height),
        Padding(
          padding: MediaQuery.paddingOf(context)
              .add(EdgeInsets.symmetric(horizontal: 16.0)),
          child: BaseView<HomePageBloc, PageEvent, PageBlocState,
              PageNotification>(
            initialEvent: Init(),
            onNotification:
                (BuildContext context, PageNotification notification) {
              switch (notification) {
                case ErrorNotification():
                // TODO: Handle this case.
              }
            },
            builder: (BuildContext context, PageBlocState state) {
              return switch (state) {
                InitialState() || LoadingState() => Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ErrorState() => Center(
                    child: Text(state.errorMessage),
                  ),
                UpdatedState() => Stack(children: [
                    Positioned(
                      top: 16,
                      bottom: 4,
                      left: 2,
                      right: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: state.chatNotifications.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    state.chatNotifications[index].message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 8,
                      left: 8,
                      child: NeumorfismContainer(
                          radius: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                NeumorfismContainer(
                                  radius: 12,
                                  isInset: true,
                                  constraints: BoxConstraints(maxWidth: 250),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      maxLines: 3,
                                      minLines: 1,
                                    ),
                                  ),
                                ),
                                S.s4(),
                                NeumorfismButton(
                                  onPress: () {},
                                  radius: 12,
                                  blurRadius: 16,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(Icons.send),
                                  ),
                                ),
                                S.s2(),
                              ],
                            ),
                          )),
                    )
                  ]),
              };
            },
          ),
        ),
      ]),
    );
  }
}
