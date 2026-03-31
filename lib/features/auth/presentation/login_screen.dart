import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/errors/failures.dart';
import 'providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String? redirectPath;

  const LoginScreen({
    super.key,
    this.redirectPath,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ─── Lógica ────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    try {
      await ref.read(signInUseCaseProvider).call(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (mounted) {
        context.go(widget.redirectPath ?? '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Bienvenido de vuelta! 📚'),
            backgroundColor: InkColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _error = mapExceptionToFailure(e).message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ─── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : context.go('/home'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  padding: EdgeInsets.zero,
                ),

                const SizedBox(height: 32),

                _HeaderIcon(icon: Icons.login_rounded)
                    .animate()
                    .fadeIn()
                    .scale(begin: const Offset(0.8, 0.8)),

                const SizedBox(height: 20),

                Text('Inicia sesión', style: InkTextStyles.displayMedium)
                    .animate().fadeIn(delay: 80.ms),

                const SizedBox(height: 6),

                Text(
                  'Accede a tu biblioteca personal.',
                  style: InkTextStyles.bodyLarge
                      .copyWith(color: InkColors.textSecondary),
                ).animate().fadeIn(delay: 120.ms),

                const SizedBox(height: 36),

                // Error banner
                if (_error != null)
                  _ErrorBanner(message: _error!)
                      .animate()
                      .shake(hz: 3, offset: const Offset(4, 0)),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email_outlined,
                        color: InkColors.textHint),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu correo';
                    if (!v.contains('@')) return 'Correo inválido';
                    return null;
                  },
                ).animate().fadeIn(delay: 160.ms),

                const SizedBox(height: 16),

                // Contraseña
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: InkColors.textHint),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: InkColors.textHint,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const _LoadingIndicator()
                      : const Text('Iniciar sesión'),
                ).animate().fadeIn(delay: 240.ms),

                const SizedBox(height: 24),

                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('¿Sin cuenta? ',
                          style: InkTextStyles.bodyMedium),
                      GestureDetector(
                        onTap: () => context.go('/auth/register'),
                        child: Text(
                          'Regístrate aquí',
                          style: InkTextStyles.bodyMedium.copyWith(
                            color: InkColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 280.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Widgets compartidos con register ───────────────────────────────────────

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: InkColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, size: 28, color: InkColors.primary),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: InkColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InkColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: InkColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: InkTextStyles.bodyMedium.copyWith(
                color: InkColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    );
  }
}
