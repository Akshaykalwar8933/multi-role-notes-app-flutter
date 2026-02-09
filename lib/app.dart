import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/bloc/notes/notes_bloc.dart';
import 'presentation/bloc/notes/notes_event.dart';

import 'presentation/screens/login_screen.dart';
import 'presentation/screens/note_screen.dart';

import 'utils/constants/app_strings.dart';
import 'utils/theme/app_theme.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.read<NotesBloc>().add(LoadNotes());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return NotesScreen(
              isAdmin: state.role == AppStrings.admin,
            );
          }
          return const LoginScreen();
        },
      ),
    );
  }
}

