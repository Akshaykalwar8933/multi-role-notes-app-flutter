import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_root.dart';
import 'data/local_data.dart';
import 'data/models/note_model.dart';
import 'data/repositories/note_repository_impl.dart';

import 'presentation/bloc/notes/notes_bloc.dart';
import 'presentation/bloc/notes/notes_event.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/theme/theme_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());

  final notesBox = await Hive.openBox<NoteModel>('notes');
  final authBox = await Hive.openBox('auth');
  final themeBox = await Hive.openBox('theme');

  final noteRepository = NoteRepositoryImpl(
    NoteLocalDataSource(notesBox),
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => NotesBloc(noteRepository)..add(LoadNotes()),
          ),
          BlocProvider(
            create: (_) => AuthBloc(authBox)..add(LoadSavedRoleEvent()),
          ),
          BlocProvider(
            create: (_) => ThemeBloc(themeBox)..add(LoadThemeEvent()),
          ),
        ],
        child:  RootApp(),
      ),
    ),
  );
}
