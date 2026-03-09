import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../domain/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
  }

  final AuthRepository authRepository;

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.get();
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await authRepository.createSession(
        email: event.email,
        password: event.password,
      );
      final user = await authRepository.get();
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await authRepository.create(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      await authRepository.createSession(
        email: event.email,
        password: event.password,
      );
      final user = await authRepository.get();
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await authRepository.deleteSession(sessionId: 'current');
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
