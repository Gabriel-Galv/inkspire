import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// Envuelve cualquier widget que requiera sesión activa.
// Si el usuario no tiene sesión, intercepta el tap y muestra
// un bottom sheet invitándolo a iniciar sesión o registrarse.

class AuthGate extends ConsumerWidget {
  final Widget child;
  final String? message;

  const AuthGate({
    super.key,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    // Con sesión → muestra el widget real sin interferir
    if (isLoggedIn) return child;

    // Sin sesión → intercepta el tap con el sheet de auth
    return GestureDetector(
      onTap: () => _showAuthSheet(context),
      behavior: HitTestBehavior.opaque,
      child: AbsorbPointer(child: child),
    );
  }

  void _showAuthSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AuthSheet(message: message),
    );
  }
}

class _AuthSheet extends StatelessWidget {
  final String? message;
  const _AuthSheet({this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Sube el sheet cuando aparece el teclado
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: BoxDecoration(
          color: InkColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: InkColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            // Ícono
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: InkColors.primarySurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 30,
                color: InkColors.primary,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Inicia sesión para continuar',
              style: InkTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              message ??
                  'Crea una cuenta gratis para guardar tus '
                  'libros favoritos y organizar tu lectura.',
              style: InkTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // Botón principal
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/auth/login');
              },
              child: const Text('Iniciar sesión'),
            ),

            const SizedBox(height: 12),

            // Botón secundario
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/auth/register');
              },
              child: const Text('Crear cuenta gratis'),
            ),
          ],
        ),
      ),
    );
  }
}