import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/book_card.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../search/presentation/providers/search_provider.dart';

class FeaturedBooksCarousel extends ConsumerWidget {
  const FeaturedBooksCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(featuredBooksProvider);

    return SizedBox(
      height: 260,
      child: booksAsync.when(
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, __) => const BookCardSkeleton(),
        ),
        error: (_, __) => const Center(
          child: Icon(Icons.error_outline_rounded, size: 36),
        ),
        data: (books) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: books.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, i) => BookCard(book: books[i])
              .animate()
              .fadeIn(delay: Duration(milliseconds: 60 * i)),
        ),
      ),
    );
  }
}