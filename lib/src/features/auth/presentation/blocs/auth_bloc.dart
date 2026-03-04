import 'package:andika/src/features/auth/data/auth_repo_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepoImpl}) : super(AuthInitial()) {
    on<SignOutEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepoImpl.signOut();
        emit(AuthLoggedOut());
      } catch (e) {
        emit(AuthError(''));
      }
    });
    on<SignInEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepoImpl.signInEmailAndPassword(event.email, event.password);
        emit(AuthSuccessLogin());
      } catch (e) {
        emit(AuthError(''));
      }
    });
    on<ResetPasswordEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepoImpl.resetPassword(event.email);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(''));
      }
    });
    on<ChangePasswordEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepoImpl.resetPassword('');
        emit(ResetPasswordSuccess());
      } catch (e) {
        emit(AuthError(''));
      }
    });
  }
  final AuthRepoImpl authRepoImpl;
}
