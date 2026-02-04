abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String role;
  Authenticated(this.role);
}
