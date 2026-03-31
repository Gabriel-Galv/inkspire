import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme.dart';
import '../../../features/search/presentation/providers/search_provider.dart';
import 'widgets/action_buttons_row.dart';
import 'widgets/book_hero_header.dart';

class BookDetailScreen extends ConsumerWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookDetailProvider(bookId));

    return Scaffold(
      body: bookAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: InkColors.primary),
        ),
        error: (e, _) => _ErrorState(
          onBack: () => Navigator.pop(context),
          onRetry: () => ref.invalidate(bookDetailProvider(bookId)),
        ),
        data: (book) => CustomScrollView(
          slivers: [
            // ── Hero con portada ─────────────────────────────────────────
            BookHeroHeader(book: book),

            // ── Contenido ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _BookContent(book: book),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Contenido principal ──────────────────────────────────────────────────────
class _BookContent extends ConsumerStatefulWidget {
  final dynamic book; // BookModel

  const _BookContent({required this.book});

  @override
  ConsumerState<_BookContent> createState() => _BookContentState();
}

class _BookContentState extends ConsumerState<_BookContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        Text(book.title, style: InkTextStyles.displayMedium)
            .animate().fadeIn(delay: 80.ms),

        const SizedBox(height: 6),

        // Autor
        Text(
          book.authorsDisplay,
          style: InkTextStyles.bodyLarge
              .copyWith(color: InkColors.primary),
        ).animate().fadeIn(delay: 120.ms),

        const SizedBox(height: 16),

        // Meta chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (book.averageRating != null)
              _MetaChip(
                icon: Icons.star_rounded,
                label:
                    '${book.averageRating!.toStringAsFixed(1)}'
                    ' (${book.ratingsCount ?? 0})',
                color: InkColors.warning,
              ),
            if (book.pageCount != null)
              _MetaChip(
                icon: Icons.menu_book_rounded,
                label: '${book.pageCount} págs.',
                color: InkColors.primary,
              ),
            if (book.yearDisplay.isNotEmpty)
              _MetaChip(
                icon: Icons.calendar_today_rounded,
                label: book.yearDisplay,
                color: InkColors.textSecondary,
              ),
            if (book.language != null)
              _MetaChip(
                icon: Icons.language_rounded,
                label: book.language!.toUpperCase(),
                color: InkColors.textSecondary,
              ),
          ],
        ).animate().fadeIn(delay: 160.ms),

        const SizedBox(height: 24),

        // Botones de acción (favorito + lista)
        ActionButtonsRow(book: book)
            .animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 28),

        // Descripción
        if (book.description != null && book.description!.isNotEmpty) ...[
          Text('Descripción', style: InkTextStyles.headlineMedium),
          const SizedBox(height: 10),
          AnimatedCrossFade(
            firstChild: Text(
              book.description!,
              style: InkTextStyles.bodyLarge,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              book.description!,
              style: InkTextStyles.bodyLarge,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Text(_expanded ? 'Leer menos' : 'Leer más'),
          ),
          const SizedBox(height: 8),
        ],

        // Detalles
        Text('Detalles', style: InkTextStyles.headlineMedium),
        const SizedBox(height: 12),
        _DetailRow('Editorial', book.publisher ?? '—'),
        _DetailRow(
            'Publicado',
            book.yearDisplay.isNotEmpty ? book.yearDisplay : '—'),
        _DetailRow('Páginas', book.pageCount?.toString() ?? '—'),
        _DetailRow('Idioma', book.language?.toUpperCase() ?? '—'),
        if (book.categories.isNotEmpty)
          _DetailRow('Géneros', book.categories.take(3).join(', ')),

        const SizedBox(height: 24),

        // Botón vista previa
        if ((book.previewLink != null && book.previewLink!.isNotEmpty) ||
            (book.infoLink != null && book.infoLink!.isNotEmpty))
          OutlinedButton.icon(
            onPressed: () async {
              try {
                // Intentar abrir en este orden: previewLink -> infoLink -> Google Books genérico
                final urlToOpen = book.previewLink?.isNotEmpty == true
                    ? book.previewLink!
                    : (book.infoLink?.isNotEmpty == true
                        ? book.infoLink!
                        : 'https://www.google.com/search?q=${Uri.encodeComponent("${book.title} ${book.authorsDisplay}")} site:books.google.com');

                final uri = Uri.parse(urlToOpen);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                } else {
                  // Fallback: intentar con diferentes configuraciones
                  try {
                    await launchUrl(uri);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'No se pudo abrir el enlace. Por favor, intenta manualmente.'),
                        ),
                      );
                    }
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text('Vista previa en Google Books'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),

        const SizedBox(height: 40),
      ],
    );
  }
}

// ─── Widgets internos ─────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: InkTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: InkTextStyles.bodyMedium
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: InkTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const _ErrorState({required this.onBack, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: InkColors.textHint),
            const SizedBox(height: 16),
            Text('No se pudo cargar el libro',
                style: InkTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Verifica tu conexión e intenta de nuevo.',
              style: InkTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onBack,
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}