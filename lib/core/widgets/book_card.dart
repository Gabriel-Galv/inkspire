import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../features/search/domain/entities/book.dart';

// ─── BookCard — tarjeta vertical para carruseles ──────────────────────────────
class BookCard extends StatelessWidget {
  final Book book;
  final double width;
  final double coverHeight;

  const BookCard({
    super.key,
    required this.book,
    this.width = 130,
    this.coverHeight = 190,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/book/${book.id}'),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portada
            _BookCover(
              book: book,
              width: width,
              height: coverHeight,
              borderRadius: 12,
            ),

            const SizedBox(height: 8),

            // Título
            Text(
              book.title,
              style: InkTextStyles.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            // Autor
            Text(
              book.authorsDisplay,
              style: InkTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Rating (opcional)
            if (book.averageRating != null) ...[
              const SizedBox(height: 4),
              _RatingRow(rating: book.averageRating!),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── BookListTile — fila horizontal para listas ───────────────────────────────
class BookListTile extends StatelessWidget {
  final Book book;
  final Widget? trailing;

  const BookListTile({super.key, required this.book, this.trailing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/book/${book.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: InkColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: InkColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            // Portada pequeña
            _BookCover(
              book: book,
              width: 56,
              height: 76,
              borderRadius: 8,
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: InkTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    book.authorsDisplay,
                    style: InkTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.categories.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _CategoryBadge(label: book.categories.first),
                  ],
                ],
              ),
            ),

            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Widgets internos reutilizables ──────────────────────────────────────────

class _BookCover extends StatefulWidget {
  final Book book;
  final double width;
  final double height;
  final double borderRadius;

  const _BookCover({
    required this.book,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<_BookCover> createState() => _BookCoverState();
}

class _BookCoverState extends State<_BookCover> {
  late String? _currentImageUrl;
  int _failureCount = 0;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.book.highResThumbnail;
  }

  void _onImageError() {
    // Si falla con zoom=2, intenta con zoom=1
    if (_failureCount == 0 && widget.book.thumbnailUrl != null) {
      setState(() {
        _currentImageUrl = widget.book.thumbnailUrl!
            .replaceAll('http://', 'https://')
            .replaceAll('zoom=2', 'zoom=1');
        _failureCount++;
      });
    } else if (_failureCount == 1 && widget.book.thumbnailUrl != null) {
      // Si aún falla, intenta sin modificar los parámetros zoom
      setState(() {
        _currentImageUrl = widget.book.thumbnailUrl!
            .replaceAll('http://', 'https://');
        _failureCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: _currentImageUrl != null
            ? CachedNetworkImage(
                imageUrl: _currentImageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _Placeholder(book: widget.book),
                errorWidget: (_, __, ___) {
                  _onImageError();
                  return _Placeholder(book: widget.book);
                },
                httpHeaders: {
                  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                },
                maxHeightDiskCache: 600,
                maxWidthDiskCache: 500,
              )
            : _Placeholder(book: widget.book),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final Book book;
  const _Placeholder({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            InkColors.primarySurface,
            InkColors.primarySurface.withOpacity(0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu_book_rounded,
            size: 32,
            color: InkColors.primary,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              book.title,
              textAlign: TextAlign.center,
              style: InkTextStyles.titleMedium.copyWith(
                color: InkColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              book.authorsDisplay,
              textAlign: TextAlign.center,
              style: InkTextStyles.bodySmall.copyWith(
                color: InkColors.primary.withOpacity(0.7),
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final double rating;
  const _RatingRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 13, color: InkColors.warning),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: InkTextStyles.bodySmall.copyWith(
            color: InkColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: InkColors.primarySurface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: InkTextStyles.bodySmall.copyWith(
          color: InkColors.primary,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}