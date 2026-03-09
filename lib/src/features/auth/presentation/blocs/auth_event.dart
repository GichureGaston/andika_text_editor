part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInEvent extends AuthEvent {
  const SignInEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  @override
  List<Object?> get props => [email, password, name];
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

class CheckAuthEvent extends AuthEvent {
  const CheckAuthEvent();
}
