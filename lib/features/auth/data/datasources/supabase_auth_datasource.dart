import 'package:supabase_flutter/supabase_flutter.dart';

// Fuente de datos de autenticación — habla directamente con Supabase Auth.
// Solo esta clase conoce los detalles del SDK de Supabase.
class AuthDatasource {
  final SupabaseClient _client;
  AuthDatasource(this._client);

  Session? get currentSession => _client.auth.currentSession;
  User?    get currentUser    => _client.auth.currentUser;

  // Emite null cuando no hay sesión, emite Session cuando hay sesión activa
  Stream<Session?> get sessionStream =>
      _client.auth.onAuthStateChange.map((state) => state.session);

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    await _client.auth.updateUser(
      UserAttributes(
        data: {
          if (fullName  != null) 'full_name':  fullName,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
        },
      ),
    );
  }
}