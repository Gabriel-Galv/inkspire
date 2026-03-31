import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/supabase_auth_datasource.dart';

// Implementación concreta del contrato AuthRepository.
// Delega todo al datasource y puede añadir lógica de transformación aquí.
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;
  AuthRepositoryImpl(this._datasource);

  @override
  Session? get currentSession => _datasource.currentSession;

  @override
  User? get currentUser => _datasource.currentUser;

  @override
  bool get isLoggedIn => _datasource.currentSession != null;

  @override
  Stream<Session?> get sessionStream => _datasource.sessionStream;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) =>
      _datasource.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) =>
      _datasource.signIn(email: email, password: password);

  @override
  Future<void> signOut() => _datasource.signOut();

  @override
  Future<void> resetPassword(String email) =>
      _datasource.resetPassword(email);

  @override
  Future<void> updateProfile({String? fullName, String? avatarUrl}) =>
      _datasource.updateProfile(fullName: fullName, avatarUrl: avatarUrl);
}