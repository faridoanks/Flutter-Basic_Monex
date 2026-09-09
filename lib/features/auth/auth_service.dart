import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '900863701469-nhnc5f8if5lnh23mv8iicl13j6pdr7om.apps.googleusercontent.com',
    );

    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'username': username.trim(),
      'email': email.trim(),
    });

    return credential;
  }

  Future<UserCredential> login({
    required String identifier,
    required String password,
  }) async {
    String email;

    // Kalau input mengandung @ → anggap sebagai email
    if (identifier.contains('@')) {
      email = identifier.trim();
    } else {
      // Kalau bukan email → cari username di Firestore
      final result = await _firestore
          .collection('users')
          .where('username', isEqualTo: identifier.trim())
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        throw Exception('User not found');
      }

      // Ambil email milik username tersebut
      email = result.docs.first.data()['email'];
    }

    // Firebase Auth tetap login menggunakan email + password
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://monex-6b019.firebaseapp.com/reset-password',
      handleCodeInApp: true,
      androidPackageName: 'com.example.monex',
      androidInstallApp: true,
      androidMinimumVersion: '1',
    );

    await _auth.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );
  }

  // USER YANG SEDANG LOGIN
  User? currentUser() {
    return _auth.currentUser;
  }
}
