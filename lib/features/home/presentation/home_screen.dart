import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/book_card.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../search/presentation/providers/search_provider.dart' hide categoryBooksProvider;
import 'providers/home_provider.dart';
import 'widgets/category_chips.dart';
import 'widgets/featured_books_carousel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final userName   = ref.watch(currentUserNameProvider);
    final trendingAsync = ref.watch(categoryBooksProvider('thriller'));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────────────────────────────
          SliverAppBar(
            floating: true,
            toolbarHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isLoggedIn && userName.isNotEmpty
                                  ? 'Hola, $userName 👋'
                                  : 'Buenas tardes',
                              style: InkTextStyles.bodyMedium,
                            ),
                            Text(
                              'Descubre libros',
                              style: InkTextStyles.displayMedium,
                            ),
                          ],
                        ),
                      ),
                      // Avatar / Login button
                      GestureDetector(
                        onTap: () => isLoggedIn
                            ? null
                            : context.push('/auth/login'),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isLoggedIn
                                ? InkColors.primary
                                : InkColors.primarySurface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            isLoggedIn
                                ? Icons.person_rounded
                                : Icons.person_outline_rounded,
                            color: isLoggedIn
                                ? Colors.white
                                : InkColors.primary,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Barra de búsqueda (decorativa, navega a /search) ──────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: GestureDetector(
                    onTap: () => context.go('/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: InkColors.surfaceCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: InkColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              color: InkColors.textHint, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Buscar por título, autor…',
                            style: InkTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.15),

                // ── Banner guest ─────────────────────────────────────────
                if (!isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: InkColors.primarySurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: InkColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_stories_rounded,
                            color: InkColors.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Guarda tus favoritos',
                                  style: InkTextStyles.titleMedium.copyWith(
                                    color: InkColors.primary,
                                  ),
                                ),
                                Text(
                                  'Inicia sesión para organizar tu lectura',
                                  style: InkTextStyles.bodySmall.copyWith(
                                    color: InkColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/auth/login'),
                            style: TextButton.styleFrom(
                              backgroundColor: InkColors.primary,
                              foregroundColor: Colors.white,
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Entrar',
                                style: TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 120.ms),

                // ── Categorías ───────────────────────────────────────────
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 12),
                  child: Text('Categorías',
                      style: InkTextStyles.headlineMedium),
                ),
                const CategoryChips(),

                // ── Destacados ───────────────────────────────────────────
                const SizedBox(height: 28),
                _SectionHeader(
                  title: 'Destacados',
                  onSeeAll: () =>
                      context.go('/search?q=bestsellers'),
                ),
                const SizedBox(height: 12),
                const FeaturedBooksCarousel(),

                // ── Tendencias ───────────────────────────────────────────
                const SizedBox(height: 28),
                _SectionHeader(
                  title: 'Tendencias',
                  onSeeAll: () =>
                      context.go('/search?q=trending books'),
                ),
                const SizedBox(height: 12),
                trendingAsync.when(
                  loading: () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 3,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, _) => const BookListTileSkeleton(),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (books) => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: books.take(5).length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => BookListTile(book: books[i])
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: 60 * i),
                        ),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: InkTextStyles.headlineMedium),
          TextButton(
            onPressed: onSeeAll,
            child: const Text('Ver todos'),
          ),
        ],
      ),
    );
  }
}