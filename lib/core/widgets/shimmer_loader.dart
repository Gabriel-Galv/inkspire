import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/theme.dart';

// ─── Base shimmer ─────────────────────────────────────────────────────────────
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: InkColors.border,
      highlightColor: InkColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: InkColors.border,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// ─── Skeleton para BookCard (carrusel vertical) ───────────────────────────────
class BookCardSkeleton extends StatelessWidget {
  final double width;
  const BookCardSkeleton({super.key, this.width = 130});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: InkColors.border,
      highlightColor: InkColors.surface,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portada
            Container(
              width: width,
              height: 190,
              decoration: BoxDecoration(
                color: InkColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            // Título línea 1
            Container(
              height: 13,
              width: width * 0.9,
              decoration: BoxDecoration(
                color: InkColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            // Título línea 2
            Container(
              height: 13,
              width: width * 0.6,
              decoration: BoxDecoration(
                color: InkColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            // Autor
            Container(
              height: 11,
              width: width * 0.7,
              decoration: BoxDecoration(
                color: InkColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Skeleton para BookListTile (lista horizontal) ────────────────────────────
class BookListTileSkeleton extends StatelessWidget {
  const BookListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: InkColors.border,
      highlightColor: InkColors.surface,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: InkColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: InkColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            // Portada
            Container(
              width: 56,
              height: 76,
              decoration: BoxDecoration(
                color: InkColors.border,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 13,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: InkColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 13,
                    width: 180,
                    decoration: BoxDecoration(
                      color: InkColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 22,
                    width: 80,
                    decoration: BoxDecoration(
                      color: InkColors.border,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Lista de skeletons para search ──────────────────────────────────────────
class SearchSkeletonList extends StatelessWidget {
  final int count;
  const SearchSkeletonList({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const BookListTileSkeleton(),
    );
  }
}