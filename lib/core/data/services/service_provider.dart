import 'package:monex/core/data/services/firestore_service.dart';
import 'package:riverpod/riverpod.dart';
import 'package:monex/features/auth/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);
