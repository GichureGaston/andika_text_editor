import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepo authRepo})
    : _authRepo = authRepo,
      super(const AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
  }

  final AuthRepo _authRepo;

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepo.getCurrentUser();
      user != null
          ? emit(AuthAuthenticated(user: user))
          : emit(const AuthUnauthenticated());
    } on Exception catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepo.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } on Exception catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepo.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      emit(AuthAuthenticated(user: user));
    } on Exception catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _authRepo.signOut();
      emit(const AuthUnauthenticated());
    } on Exception catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  late final AuthRepository? authRepository;
}
