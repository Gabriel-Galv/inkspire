import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import 'providers/reading_list_provider.dart';

class ReadingListScreen extends ConsumerWidget {
  const ReadingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(readingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Lista de Lectura'),
        elevation: 0,
        backgroundColor: InkColors.surfaceCard,
      ),
      body: listAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: InkColors.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: InkColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar tu lista',
                style: InkTextStyles.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: InkTextStyles.bodyMedium.copyWith(
                  color: InkColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(readingListProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 64,
                    color: InkColors.textSecondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tu lista de lectura está vacía',
                    style: InkTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega libros desde el buscador o tu inicio',
                    style: InkTextStyles.bodyMedium.copyWith(
                      color: InkColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/search'),
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Buscar libros'),
                  ),
                ],
              ),
            );
          }

          // Agrupar libros por estado
          final Map<String, List<Map<String, dynamic>>> grouped = {};
          for (final book in books) {
            final status = book['status'] ?? 'want_to_read';
            grouped.putIfAbsent(status, () => []).add(book);
          }

          const statusOrder = ['want_to_read', 'reading', 'finished'];
          final statusLabels = {
            'want_to_read': 'Quiero leer',
            'reading': 'Leyendo',
            'finished': 'Terminado',
          };

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...statusOrder
                  .where((s) => grouped.containsKey(s))
                  .map((status) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: Row(
                              children: [
                                Text(
                                  statusLabels[status] ?? status,
                                  style: InkTextStyles.headlineMedium,
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: InkColors.primarySurface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${grouped[status]!.length}',
                                    style:
                                        InkTextStyles.labelSmall.copyWith(
                                      color: InkColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...grouped[status]!.map((book) {
                            return _BookListTile(book: book);
                          }),
                          const SizedBox(height: 16),
                        ],
                      ))
                  .toList(),
            ],
          );
        },
      ),
    );
  }
}

class _BookListTile extends ConsumerWidget {
  final Map<String, dynamic> book;

  const _BookListTile({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookId = book['book_id'] as String?;
    final title = book['title'] as String?;
    final author = book['authors'] as String?;
    final imageUrl = book['image_url'] as String?;

    if (bookId == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => context.push('/book/$bookId'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: InkColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: InkColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            // Portada
            Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                color: InkColors.border,
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.book_rounded, size: 48),
                    )
                  : const Icon(Icons.book_rounded, size: 48),
            ),

            // Información
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '—',
                      style: InkTextStyles.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author ?? '—',
                      style: InkTextStyles.bodySmall.copyWith(
                        color: InkColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: InkColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Agregado el ${_formatDate(book['created_at'])}',
                          style: InkTextStyles.labelSmall.copyWith(
                            color: InkColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Botón más opciones
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'want_to_read' || value == 'reading' || value == 'finished') {
                  ref
                      .read(updateReadingStatusUseCaseProvider)
                      .call(bookId, value);
                  ref.invalidate(readingListProvider);
                } else if (value == 'details') {
                  context.push('/book/$bookId');
                } else if (value == 'remove') {
                  ref
                      .read(removeFromReadingListUseCaseProvider)
                      .call(bookId);
                  ref.invalidate(readingListProvider);
                }
              },
              itemBuilder: (context) {
                final currentStatus = book['status'] ?? 'want_to_read';
                return <PopupMenuEntry<String>>[
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    enabled: false,
                    value: '',
                    child: Text(
                      'Estado',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'want_to_read',
                    child: Row(
                      children: [
                        if (currentStatus == 'want_to_read')
                          const Icon(Icons.check, color: InkColors.primary),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Quiero leer')),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'reading',
                    child: Row(
                      children: [
                        if (currentStatus == 'reading')
                          const Icon(Icons.check, color: InkColors.primary),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Leyendo')),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'finished',
                    child: Row(
                      children: [
                        if (currentStatus == 'finished')
                          const Icon(Icons.check, color: InkColors.primary),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Terminado')),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'details',
                    child: Text('Ver detalles'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'remove',
                    child: Text(
                      'Quitar',
                      style: TextStyle(color: InkColors.error),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return '—';
    try {
      final dt = DateTime.parse(date);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '—';
    }
  }
}

