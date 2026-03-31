import 'package:supabase_flutter/supabase_flutter.dart';

// Contrato que define qué puede hacer la capa de auth.
// La presentación depende de esta interfaz, nunca de la implementación.
abstract class AuthRepository {
  // Estado actual
  Session? get currentSession;
  User?    get currentUser;
  bool     get isLoggedIn;

  // Stream de cambios de sesión
  Stream<Session?> get sessionStream;

  // Operaciones
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  });

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> resetPassword(String email);

  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  });
}