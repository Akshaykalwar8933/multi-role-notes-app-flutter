import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Box box;

  AuthBloc(this.box) : super(AuthInitial()) {
    on<SelectRoleEvent>(_selectRole);
    on<LoadSavedRoleEvent>(_loadRole);
    on<LogoutEvent>(_logout);
  }

  Future<void> _selectRole(
    SelectRoleEvent event,
    Emitter<AuthState> emit,
  ) async {
    await box.put("role", event.role);
    emit(Authenticated(event.role));
  }

  void _loadRole(LoadSavedRoleEvent event, Emitter<AuthState> emit) {
    final role = box.get("role");
    if (role != null) {
      emit(Authenticated(role));
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    await box.clear();
    emit(AuthInitial());
  }
}
