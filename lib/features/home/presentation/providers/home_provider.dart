import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../search/data/models/book_model.dart';
import '../../../search/presentation/providers/search_provider.dart';

// Categorías disponibles en el home
const List<String> homeCategories = [
  'Ficción',
  'Ciencia',
  'Historia',
  'Thriller',
  'Romance',
  'Arte',
  'Filosofía',
  'Tecnología',
];

// Categoría activa en los chips del home
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// ─── Data Providers ──────────────────────────────────────────────────────────

/// Libros de una categoría específica
final categoryBooksProvider =
    FutureProvider.family<List<BookModel>, String>((ref, category) async {
  if (category.isEmpty) return [];
  final results = await ref.watch(searchBooksUseCaseProvider).call(category);
  return results.cast<BookModel>();
});

/// Libros destacados para el carrusel del home
final featuredBooksProvider = FutureProvider<List<BookModel>>((ref) async {
  final results = await ref.watch(getFeaturedBooksUseCaseProvider).call();
  return results.cast<BookModel>();
});