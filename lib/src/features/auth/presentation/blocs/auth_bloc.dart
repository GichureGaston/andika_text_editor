import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<CheckAuthEvent>((CheckAuthEvent event, Emitter<AuthState> emit) async {
      emit(const AuthLoading());
      try {
        final user = await authRepository?.get();
        emit(AuthAuthenticated());
      } catch (e) {
        emit(const AuthUnauthenticated());
      }
    });
    on<SignInEvent>((SignInEvent event, Emitter<AuthState> emit) async {
      emit(const AuthLoading());
      try {
        await authRepository?.createSession(
          email: event.email,
          password: event.password,
        );
        final user = await authRepository?.get();
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
    on<SignUpEvent>((SignUpEvent event, Emitter<AuthState> emit) async {
      emit(const AuthLoading());
      try {
        await authRepository?.create(
          email: event.email,
          password: event.password,
          name: event.name,
        );
        await authRepository?.createSession(
          email: event.email,
          password: event.password,
        );
        final user = await authRepository?.get();
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
    on<SignOutEvent>((SignOutEvent event, Emitter<AuthState> emit) async {
      emit(const AuthLoading());
      try {
        await authRepository?.deleteSession(sessionId: 'current');
        emit(const AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
  }

  late final AuthRepository? authRepository;
}
