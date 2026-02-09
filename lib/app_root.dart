import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_roles_notes_app/presentation/bloc/theme/theme_bloc.dart';
import 'package:multi_roles_notes_app/presentation/bloc/theme/theme_state.dart';
import 'package:multi_roles_notes_app/utils/theme/app_theme.dart';
import 'app.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeState.isDark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          home: const MyApp(),
        );
      },
    );
  }
}

