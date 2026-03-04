import 'package:andika/src/features/auth/domain/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl extends AuthRepository {
  AuthRepoImpl(this._firebase);
  final FirebaseAuth _firebase;
  @override
  Future<void> resetPassword(String? email) async {
    // TODO: implement resetPassword
    return _firebase.confirmPasswordReset(code: '', newPassword: '');
  }

  @override
  Future<void> signInEmailAndPassword(String? email, String? password) async {
    // TODO: implement signInEmailAndPassword
    await _firebase.signInWithEmailAndPassword(email: '', password: '');
    return;
  }

  @override
  Future<void> signOut() async {
    // TODO: implement signOut
    await _firebase.signOut();
  }

  @override
  Future<void> signUpEmailAndPassword(
    String? email,
    String? password, {
    String? name,
  }) async {
    // TODO: implement signUpEmailAndPassword
    try {
      await _firebase.createUserWithEmailAndPassword(email: '', password: '');
      return;
    } catch (e) {
      rethrow;
    }
  }
}
