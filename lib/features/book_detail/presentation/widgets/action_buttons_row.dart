import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../core/widgets/auth_gate.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../reading_list/presentation/providers/reading_list_provider.dart';
import '../../../search/data/models/book_model.dart';

class ActionButtonsRow extends ConsumerWidget {
  final BookModel book;

  const ActionButtonsRow({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn  = ref.watch(isLoggedInProvider);
    final isFavAsync  = ref.watch(isFavoriteProvider(book.id));
    final statusAsync = ref.watch(bookStatusProvider(book.id));

    return Row(
      children: [
        // ── Botón favorito ─────────────────────────────────────────────────
        Expanded(
          child: AuthGate(
            message: 'Inicia sesión para guardar favoritos.',
            child: _FavoriteButton(
              book:        book,
              isFav:       isFavAsync.valueOrNull ?? false,
              isLoggedIn:  isLoggedIn,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ── Botón lista de lectura ─────────────────────────────────────────
        Expanded(
          child: AuthGate(
            message: 'Inicia sesión para añadir a tu lista.',
            child: _ReadingListButton(
              book:       book,
              status:     statusAsync.valueOrNull,
              isLoggedIn: isLoggedIn,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Favorite Button ──────────────────────────────────────────────────────────
class _FavoriteButton extends ConsumerWidget {
  final BookModel book;
  final bool isFav;
  final bool isLoggedIn;

  const _FavoriteButton({
    required this.book,
    required this.isFav,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: isLoggedIn
          ? () async {
              if (isFav) {
                await ref.read(removeFavoriteUseCaseProvider).call(book.id);
              } else {
                await ref.read(saveFavoriteUseCaseProvider).call(book);
              }
              ref.invalidate(isFavoriteProvider(book.id));
              ref.invalidate(favoritesProvider);
            }
          : null,
      icon: Icon(
        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        size: 18,
      ),
      label: Text(isFav ? 'Guardado' : 'Favorito'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isFav ? InkColors.accent : InkColors.primary,
        minimumSize: const Size(0, 48),
      ),
    );
  }
}

// ─── Reading List Button ──────────────────────────────────────────────────────
class _ReadingListButton extends ConsumerWidget {
  final BookModel book;
  final String? status;
  final bool isLoggedIn;

  const _ReadingListButton({
    required this.book,
    required this.status,
    required this.isLoggedIn,
  });

  String _label(String s) => switch (s) {
        'want_to_read' => 'Quiero leer',
        'reading'      => 'Leyendo',
        'finished'     => 'Terminado',
        _              => 'Mi lista',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasStatus = status != null;

    return OutlinedButton.icon(
      onPressed: isLoggedIn
          ? () => _showStatusSheet(context, ref)
          : null,
      icon: Icon(
        hasStatus ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        size: 18,
      ),
      label: Text(hasStatus ? _label(status!) : 'Mi lista'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        foregroundColor: hasStatus ? InkColors.success : InkColors.primary,
        side: BorderSide(
          color: hasStatus ? InkColors.success : InkColors.primary,
        ),
      ),
    );
  }

  void _showStatusSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _StatusSheet(
        book:          book,
        currentStatus: status,
        ref:           ref,
      ),
    );
  }
}

// ─── Status Bottom Sheet ──────────────────────────────────────────────────────
class _StatusSheet extends StatelessWidget {
  final BookModel book;
  final String?   currentStatus;
  final WidgetRef ref;

  const _StatusSheet({
    required this.book,
    required this.currentStatus,
    required this.ref,
  });

  static const _options = [
    (id: 'want_to_read', label: 'Quiero leer',
        icon: Icons.bookmark_border_rounded, color: InkColors.primary),
    (id: 'reading',      label: 'Leyendo',
        icon: Icons.menu_book_rounded,       color: InkColors.success),
    (id: 'finished',     label: 'Terminado',
        icon: Icons.check_circle_rounded,    color: InkColors.warning),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: InkColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: InkColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text('Añadir a lista', style: InkTextStyles.headlineMedium),
          const SizedBox(height: 12),

          // Opciones de estado
          ..._options.map((opt) => ListTile(
            leading: Icon(opt.icon, color: opt.color),
            title: Text(opt.label, style: InkTextStyles.titleMedium),
            trailing: currentStatus == opt.id
                ? const Icon(Icons.check_rounded, color: InkColors.primary)
                : null,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onTap: () async {
              Navigator.pop(context);
              await ref
                  .read(addToReadingListUseCaseProvider)
                  .call(book, opt.id);
              ref.invalidate(bookStatusProvider(book.id));
              ref.invalidate(readingListProvider);
            },
          )),

          // Quitar de la lista
          if (currentStatus != null) ...[
            const Divider(height: 16),
            ListTile(
              leading: const Icon(
                  Icons.delete_outline_rounded, color: InkColors.error),
              title: Text(
                'Quitar de mi lista',
                style: InkTextStyles.titleMedium
                    .copyWith(color: InkColors.error),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () async {
                Navigator.pop(context);
                await ref
                    .read(removeFromReadingListUseCaseProvider)
                    .call(book.id);
                ref.invalidate(bookStatusProvider(book.id));
                ref.invalidate(readingListProvider);
              },
            ),
          ],
        ],
      ),
    );
  }
}