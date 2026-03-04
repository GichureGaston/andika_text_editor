part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class ResetPasswordSuccess extends AuthState {}

final class AuthSuccessLogin extends AuthState {}

final class AuthLoggedOut extends AuthState {}

final class AuthError extends AuthState {
  AuthError(this.messageError);
  final String messageError;
  List<Object> get props => [messageError];
}
