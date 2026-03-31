import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../search/domain/entities/book.dart';

class BookHeroHeader extends StatelessWidget {
  final Book book;

  const BookHeroHeader({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      backgroundColor: InkColors.surface,
      leading: _BackButton(),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Fondo difuminado con la portada
            _BackgroundCover(url: book.highResThumbnail),

            // Gradiente inferior para suavizar la transición
            const _BottomGradient(),

            // Portada centrada
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Hero(
                  tag: 'book-cover-${book.id}',
                  child: _FrontCover(book: book),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _BackgroundCover extends StatelessWidget {
  final String? url;
  const _BackgroundCover({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null) return Container(color: InkColors.primary);

    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.55),
      colorBlendMode: BlendMode.darken,
      errorWidget: (_, __, ___) => Container(color: InkColors.primary),
    );
  }
}

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 80,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.2),
            ],
          ),
        ),
      ),
    );
  }
}

class _FrontCover extends StatelessWidget {
  final Book book;
  const _FrontCover({required this.book});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 130,
        height: 190,
        child: book.highResThumbnail != null
            ? CachedNetworkImage(
                imageUrl: book.highResThumbnail!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _Placeholder(book: book),
              )
            : _Placeholder(book: book),
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
      color: InkColors.primarySurface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_rounded,
              size: 40, color: InkColors.primary),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              book.title,
              textAlign: TextAlign.center,
              style: InkTextStyles.bodySmall.copyWith(
                color: InkColors.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}