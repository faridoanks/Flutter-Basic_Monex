import 'package:firebase_auth/firebase_auth.dart';
import 'package:monex/features/auth/auth_service.dart';

class AuthRepository {
  final _authService = AuthService();


  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    await _authService.register(
      username: username,
      email: email,
      password: password,
    );
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    await _authService.login(identifier: identifier, password: password);
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  User? currentUser() {
    return _authService.currentUser();
  }
}
