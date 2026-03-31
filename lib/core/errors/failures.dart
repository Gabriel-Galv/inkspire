// Jerarquía de errores tipados para toda la app.
// Cada capa lanza Failures en lugar de excepciones crudas,
// permitiendo manejo uniforme en los providers.

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

// ─── Red ──────────────────────────────────────────────────────────────────────
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Sin conexión. Verifica tu internet.',
  ]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'La solicitud tardó demasiado. Intenta de nuevo.',
  ]);
}

// ─── Servidor ─────────────────────────────────────────────────────────────────
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Error del servidor. Intenta más tarde.',
  ]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'Recurso no encontrado.',
  ]);
}

// ─── Autenticación ────────────────────────────────────────────────────────────
class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Error de autenticación.',
  ]);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([
    super.message = 'Email o contraseña incorrectos.',
  ]);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure([
    super.message = 'Este correo ya está registrado.',
  ]);
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure([
    super.message = 'Tu sesión expiró. Vuelve a iniciar sesión.',
  ]);
}

// ─── Cache / Local ────────────────────────────────────────────────────────────
class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Error al acceder a datos locales.',
  ]);
}

// ─── General ──────────────────────────────────────────────────────────────────
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Ocurrió un error inesperado.',
  ]);
}

// ─── Helper: convierte excepciones de Supabase/Dio a Failures ────────────────
Failure mapExceptionToFailure(Object e) {
  final msg = e.toString().toLowerCase();

  if (msg.contains('invalid login credentials')) {
    return const InvalidCredentialsFailure();
  }
  if (msg.contains('already registered') || msg.contains('already been registered')) {
    return const EmailAlreadyInUseFailure();
  }
  if (msg.contains('jwt') || msg.contains('session') || msg.contains('token')) {
    return const SessionExpiredFailure();
  }
  if (msg.contains('network') || msg.contains('socketexception') || msg.contains('connection refused')) {
    return const NetworkFailure();
  }
  if (msg.contains('timeout')) {
    return const TimeoutFailure();
  }
  if (msg.contains('not found') || msg.contains('404')) {
    return const NotFoundFailure();
  }
  if (msg.contains('server') || msg.contains('500') || msg.contains('503')) {
    return const ServerFailure();
  }

  return UnexpectedFailure(e.toString());
}