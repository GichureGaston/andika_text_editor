import 'package:andika/src/features/auth/data/models/user_model.dart';
import 'package:andika/src/features/auth/data/remote/auth_remote_repo.dart';

class AuthRemoteRepoImpl implements AuthRemoteRepo {
  @override
  Future<UserModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signIn({required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
