abstract class AuthEvent {}

class SelectRoleEvent extends AuthEvent {
  final String role;
  SelectRoleEvent(this.role);
}

class LoadSavedRoleEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
