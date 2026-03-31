import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/data/datasources/supabase_auth_datasource.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/usecases/sign_in_usecase.dart';
import '../../../auth/domain/usecases/sign_out_usecase.dart';
import '../../../auth/domain/usecases/sign_up_usecase.dart';

// ─── Datasource ───────────────────────────────────────────────────────────────

final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  return AuthDatasource(Supabase.instance.client);
});

// ─── Repository ───────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authDatasourceProvider));
});

// ─── Use Cases ────────────────────────────────────────────────────────────────

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

// ─── Estado de sesión — usado por toda la app ─────────────────────────────────

// Stream reactivo: emite null (sin sesión) o Session (con sesión)
final authSessionProvider = StreamProvider<Session?>((ref) {
  return ref.watch(authRepositoryProvider).sessionStream;
});

// Usuario actual (null si no hay sesión)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authSessionProvider).valueOrNull?.user;
});

// Bool conveniente para guards y AuthGate
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

// Nombre para mostrar en el saludo del home
final currentUserNameProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return '';
  final fullName = user.userMetadata?['full_name'] as String?;
  if (fullName != null && fullName.isNotEmpty) {
    return fullName.split(' ').first;
  }
  return user.email?.split('@').first ?? '';
});