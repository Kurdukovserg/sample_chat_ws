import 'package:auto_route/auto_route.dart';
import 'package:chat_sample_app/core/bloc/notifiable_bloc.dart';
import 'package:chat_sample_app/core/utils/strings.dart';
import 'package:chat_sample_app/dtos/chat_notification.dart';
import 'package:chat_sample_app/presentation/components/neumorfism_button.dart';
import 'package:chat_sample_app/presentation/components/neumorfism_container.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

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
                  logError('chat error: ${notification.error}');
                // TODO: Handle this case.
              }
            },
            builder: (BuildContext context, PageBlocState state) {
              return switch (state) {
                InitialState() || LoadingState() => Center(
                    child: CircularProgressIndicator(),
                  ),
                ErrorState() => Center(
                    child: Text(state.errorMessage),
                  ),
                UpdatedState() => UpdatedChat(context, state),
              };
            },
          ),
        ),
      ]),
    );
  }
}

class UpdatedChat extends StatelessWidget {
  const UpdatedChat(
    this.context,
    this.state, {
    super.key,
  });

  final BuildContext context;
  final UpdatedState state;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
              return ChatNotificationChip(state: state, index: index);
            },
          ),
        ),
      ),
      Positioned(
        bottom: 16,
        right: 8,
        left: 8,
        child: ChatInput(),
      ),
    ]);
  }
}

class ChatNotificationChip extends StatelessWidget {
  const ChatNotificationChip({
    super.key,
    required this.state,
    required this.index,
  });

  final UpdatedState state;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final notification = state.chatNotifications[index];

    final message = notification.message;
    final date = notification.localDate.toFormattedString();
    final username = notification.user?.userName;
    final type = notification.type;

    Color resolveNotificationColor() {
      return switch (type) {
        NotificationType.server => theme.colorScheme.secondary,
        NotificationType.user => theme.colorScheme.surface,
        NotificationType.my => theme.colorScheme.primaryContainer,
        NotificationType.forMe => theme.colorScheme.tertiary,
      };
    }

    MainAxisAlignment resolveAlignment() {
      return switch (type) {
        NotificationType.server ||
        NotificationType.forMe =>
          MainAxisAlignment.center,
        NotificationType.user => MainAxisAlignment.start,
        NotificationType.my => MainAxisAlignment.end,
      };
    }

    Widget resolveNotificationChip() {
      return switch (type) {
        NotificationType.server || NotificationType.forMe => Text(
            '$date $message',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: resolveNotificationColor(),
            ),
          ),
        NotificationType.my => NeumorfismContainer(
            tint: resolveNotificationColor(),
            radius: 8,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 100),
                    child: Text(
                      message,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    date,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        NotificationType.user => NeumorfismContainer(
            tint: resolveNotificationColor(),
            radius: 8,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 100),
                    child: Text(
                      message,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    '$date $username',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.4)),
                  ),
                ],
              ),
            ),
          ),
      };
    }

    return Row(
      mainAxisAlignment: resolveAlignment(),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: resolveNotificationChip(),
        ),
      ],
    );
  }
}

class ChatInput extends StatefulWidget {
  const ChatInput({
    super.key,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final chatInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NeumorfismContainer(
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
                  controller: chatInputController,
                  decoration: InputDecoration(border: InputBorder.none),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
            ),
            S.s4(),
            NeumorfismButton(
              onPress: () {
                context
                    .read<HomePageBloc>()
                    .add(SendMessage(message: chatInputController.text));
                chatInputController.clear();
              },
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
      ),
    );
  }
}
