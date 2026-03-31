import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/book_card.dart';
import '../../../core/widgets/shimmer_loader.dart';
import 'providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis favoritos')),
      body: favoritesAsync.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, __) => const BookListTileSkeleton(),
        ),
        error: (e, _) => _ErrorState(
          onRetry: () => ref.invalidate(favoritesProvider),
        ),
        data: (books) {
          if (books.isEmpty) return const _EmptyState();

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final book = books[i];
              return BookListTile(
                book: book,
                trailing: IconButton(
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: InkColors.accent,
                    size: 22,
                  ),
                  tooltip: 'Quitar de favoritos',
                  onPressed: () async {
                    await ref
                        .read(removeFavoriteUseCaseProvider)
                        .call(book.id);
                    ref.invalidate(favoritesProvider);
                    ref.invalidate(isFavoriteProvider(book.id));
                  },
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 60 * i));
            },
          );
        },
      ),
    );
  }
}

// ─── Estados vacío y error ────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: InkColors.accentSurface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 36,
              color: InkColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text('Sin favoritos aún', style: InkTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Guarda los libros que te interesen\npara encontrarlos aquí.',
            style: InkTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 48, color: InkColors.textHint),
          const SizedBox(height: 12),
          Text('Error al cargar favoritos',
              style: InkTextStyles.bodyMedium),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(minimumSize: const Size(140, 44)),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}