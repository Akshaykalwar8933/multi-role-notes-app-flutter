import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:multi_roles_notes_app/presentation/bloc/theme/theme_event.dart';
import 'package:multi_roles_notes_app/presentation/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Box box;

  ThemeBloc(this.box) : super(ThemeState(false)) {
    on<LoadThemeEvent>(_loadTheme);
    on<ToggleThemeEvent>(_toggleTheme);
  }

  void _loadTheme(
      LoadThemeEvent event,
      Emitter<ThemeState> emit,
      ) {
    final isDark = box.get('isDark', defaultValue: false);
    emit(ThemeState(isDark));
  }

  void _toggleTheme(
      ToggleThemeEvent event,
      Emitter<ThemeState> emit,
      ) async {
    final newValue = !state.isDark;
    await box.put('isDark', newValue);
    emit(ThemeState(newValue));
  }
}
