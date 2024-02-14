part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}


class AuthLogInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLogInEvent({required this.email, required this.password});
}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpEvent({required this.password,required this.email});

}

class AuthGoogleSignInEvent extends AuthEvent {}