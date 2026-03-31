import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../search/data/models/book_model.dart';
import '../../data/datasources/supabase_favorites_datasource.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import '../../domain/usecases/save_favorite_usecase.dart';

// ─── Datasource & Repository ──────────────────────────────────────────────────

final favoritesDatasourceProvider = Provider<FavoritesDatasource>((ref) {
  return FavoritesDatasource(Supabase.instance.client);
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesDatasourceProvider));
});

// ─── Use Cases ────────────────────────────────────────────────────────────────

final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>((ref) {
  return GetFavoritesUseCase(ref.watch(favoritesRepositoryProvider));
});

final saveFavoriteUseCaseProvider = Provider<SaveFavoriteUseCase>((ref) {
  return SaveFavoriteUseCase(ref.watch(favoritesRepositoryProvider));
});

final removeFavoriteUseCaseProvider = Provider<RemoveFavoriteUseCase>((ref) {
  return RemoveFavoriteUseCase(ref.watch(favoritesRepositoryProvider));
});

// ─── State Providers ──────────────────────────────────────────────────────────

// Lista completa de favoritos del usuario
final favoritesProvider = FutureProvider<List<BookModel>>((ref) async {
  if (!ref.watch(isLoggedInProvider)) return [];
  final results = await ref.watch(getFavoritesUseCaseProvider).call();
  return results.cast<BookModel>();
});

// Saber si un libro específico es favorito (para el botón en book_detail)
final isFavoriteProvider =
    FutureProvider.family<bool, String>((ref, bookId) async {
  if (!ref.watch(isLoggedInProvider)) return false;
  return ref.watch(favoritesRepositoryProvider).isFavorite(bookId);
});