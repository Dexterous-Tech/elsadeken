import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'chat_settings_screen.dart';
import '../cubit/chat_settings_cubit.dart';
import '../cubit/lists_cubit.dart';

class ChatSettingsScreenWrapper extends StatelessWidget {
  const ChatSettingsScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatSettingsCubit>(
          create: (context) => sl<ChatSettingsCubit>(),
        ),
        BlocProvider<ListsCubit>(
          create: (context) => sl<ListsCubit>(),
        ),
      ],
      child: const ChatSettingsScreen(),
    );
  }
}

// Usage in your app:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => const ChatSettingsScreenWrapper(),
//   ),
// );
