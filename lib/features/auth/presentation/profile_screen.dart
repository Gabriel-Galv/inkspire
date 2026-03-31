import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import 'providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final userName = ref.watch(currentUserNameProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: const Center(
          child: Text('Por favor inicia sesión'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        elevation: 0,
        backgroundColor: InkColors.surfaceCard,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: InkColors.primarySurface,
                border: Border.all(
                  color: InkColors.primary,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: InkTextStyles.displayMedium.copyWith(
                    color: InkColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nombre
            Text(
              userName,
              style: InkTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Email
            Text(
              user.email ?? '—',
              style: InkTextStyles.bodyLarge.copyWith(
                color: InkColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Información
            _InfoCard(
              icon: Icons.email_rounded,
              label: 'Correo electrónico',
              value: user.email ?? '—',
            ),

            const SizedBox(height: 12),

            if (user.userMetadata?['full_name'] != null)
              _InfoCard(
                icon: Icons.person_rounded,
                label: 'Nombre completo',
                value: user.userMetadata?['full_name'] ?? '—',
              ),

            const SizedBox(height: 40),

            // Botón cerrar sesión
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(signOutUseCaseProvider).call();
                  if (context.mounted) {
                    context.go('/auth/login');
                  }
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesión'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: InkColors.error,
                  side: const BorderSide(color: InkColors.error),
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: InkColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InkColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: InkColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: InkTextStyles.labelLarge.copyWith(
                    color: InkColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: InkTextStyles.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
