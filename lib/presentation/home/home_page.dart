import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/strings.dart';
import '../../core/bloc/view.dart';
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
      body: Padding(
        padding: MediaQuery.paddingOf(context)
            .add(EdgeInsets.symmetric(horizontal: 16.0)),
        child:
            BaseView<HomePageBloc, PageEvent, PageBlocState, PageNotification>(
          onNotification:
              (BuildContext context, PageNotification notification) {
            switch (notification) {
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
                      child: Text(Strings.homeScreenName),
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
