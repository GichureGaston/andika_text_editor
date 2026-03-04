part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInUpEvent extends AuthEvent {
  const SignInUpEvent({required this.email, required this.password, this.name});
  final String? name;
  final String? email;
  final String? password;
}

class SignInEvent extends AuthEvent {
  const SignInEvent({required this.email, required this.password});

  final String? email;
  final String? password;
}

class SignOutEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {
  const ResetPasswordEvent(this.email);

  final String? email;
}

class ChangePasswordEvent extends AuthEvent {
  const ChangePasswordEvent();
}
