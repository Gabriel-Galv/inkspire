import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/profile_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/book_detail/presentation/book_detail_screen.dart';
import '../features/favorites/presentation/favorites_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/reading_list/presentation/reading_list_screen.dart';
import '../features/search/presentation/search_screen.dart';
import 'shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Escucha cambios de sesión para redirigir reactivamente
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final location = state.matchedLocation;

      // Rutas que requieren sesión activa
      const protected = ['/favorites', '/reading-list'];
      final isProtected = protected.any((r) => location.startsWith(r));

      // Si intenta entrar a ruta protegida sin sesión → login
      if (isProtected && !isLoggedIn) {
        return '/auth/login?redirect=$location';
      }

      // Si ya tiene sesión y va a auth → home
      if (location.startsWith('/auth') && isLoggedIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      // ── Shell con bottom nav ──────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                _fadePage(state, const HomeScreen()),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) {
              final query = state.uri.queryParameters['q'] ?? '';
              return _fadePage(state, SearchScreen(initialQuery: query));
            },
          ),
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) =>
                _fadePage(state, const FavoritesScreen()),
          ),
          GoRoute(
            path: '/reading-list',
            pageBuilder: (context, state) =>
                _fadePage(state, const ReadingListScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                _fadePage(state, const ProfileScreen()),
          ),
        ],
      ),

      // ── Detalle de libro (sin shell) ──────────────────────────────────────
      GoRoute(
        path: '/book/:id',
        builder: (context, state) =>
            BookDetailScreen(bookId: state.pathParameters['id']!),
      ),

      // ── Auth ──────────────────────────────────────────────────────────────
      GoRoute(
        path: '/auth/login',
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return LoginScreen(redirectPath: redirect);
        },
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
});

// Transición fade suave entre tabs del shell
CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 180),
  );
}