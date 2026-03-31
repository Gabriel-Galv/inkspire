import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../data/datasources/google_books_datasource.dart';
import '../../data/models/book_model.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/usecases/get_book_by_id_usecase.dart';
import '../../domain/usecases/get_featured_books_usecase.dart';
import '../../domain/usecases/search_books_usecase.dart';

// ─── Infrastructure ───────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout:
          Duration(seconds: ApiConstants.connectTimeoutSec),
      receiveTimeout:
          Duration(seconds: ApiConstants.receiveTimeoutSec),
      headers: {'Accept': 'application/json'},
    ),
  );
});

final googleBooksDatasourceProvider =
    Provider<GoogleBooksDatasource>((ref) {
  return GoogleBooksDatasource(ref.watch(dioProvider));
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl(ref.watch(googleBooksDatasourceProvider));
});

// ─── Use Cases ────────────────────────────────────────────────────────────────

final searchBooksUseCaseProvider = Provider<SearchBooksUseCase>((ref) {
  return SearchBooksUseCase(ref.watch(bookRepositoryProvider));
});

final getBookByIdUseCaseProvider = Provider<GetBookByIdUseCase>((ref) {
  return GetBookByIdUseCase(ref.watch(bookRepositoryProvider));
});

final getFeaturedBooksUseCaseProvider =
    Provider<GetFeaturedBooksUseCase>((ref) {
  return GetFeaturedBooksUseCase(ref.watch(bookRepositoryProvider));
});

// ─── State Providers ──────────────────────────────────────────────────────────

// Query actual en el campo de búsqueda
final searchQueryProvider = StateProvider<String>((ref) => '');

// Resultados de búsqueda — se refresca cuando cambia el query
final searchResultsProvider =
    FutureProvider.family<List<BookModel>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final results = await ref
      .watch(searchBooksUseCaseProvider)
      .call(query);
  return results.cast<BookModel>();
});

// Libros destacados para el home
final featuredBooksProvider =
    FutureProvider<List<BookModel>>((ref) async {
  final results =
      await ref.watch(getFeaturedBooksUseCaseProvider).call();
  return results.cast<BookModel>();
});

// Libros por categoría para el home
final categoryBooksProvider =
    FutureProvider.family<List<BookModel>, String>((ref, category) async {
  final results = await ref
      .watch(bookRepositoryProvider)
      .getBooksByCategory(category);
  return results.cast<BookModel>();
});

// Detalle de un libro por id
final bookDetailProvider =
    FutureProvider.family<BookModel, String>((ref, bookId) async {
  final result = await ref
      .watch(getBookByIdUseCaseProvider)
      .call(bookId);
  return result as BookModel;
});