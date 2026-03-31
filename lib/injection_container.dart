import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/api_constants.dart';
import 'features/auth/data/datasources/supabase_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/favorites/data/datasources/supabase_favorites_datasource.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/domain/repositories/favorites_repository.dart';
import 'features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'features/favorites/domain/usecases/remove_favorite_usecase.dart';
import 'features/favorites/domain/usecases/save_favorite_usecase.dart';
import 'features/favorites/presentation/providers/favorites_provider.dart';
import 'features/reading_list/data/datasources/supabase_reading_list_datasource.dart';
import 'features/reading_list/data/repositories/reading_list_repository_impl.dart';
import 'features/reading_list/domain/repositories/reading_list_repository.dart';
import 'features/reading_list/domain/usecases/reading_list_usecases.dart';
import 'features/search/data/datasources/google_books_datasource.dart';
import 'features/search/data/repositories/book_repository_impl.dart';
import 'features/search/domain/repositories/book_repository.dart';
import 'features/search/domain/usecases/get_book_by_id_usecase.dart';
import 'features/search/domain/usecases/get_featured_books_usecase.dart';
import 'features/search/domain/usecases/search_books_usecase.dart';
import 'features/search/presentation/providers/search_provider.dart';

// ─── External Dependencies ────────────────────────────────────────────────────

/// Cliente HTTP (Dio) configurado para Google Books API
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

/// Cliente Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ────────────────────────────────────────────────────────────────────────────────
// ─── AUTH LAYER ────────────────────────────────────────────────────────────────
// ────────────────────────────────────────────────────────────────────────────────

final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  return AuthDatasource(ref.watch(supabaseClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authDatasourceProvider));
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

// ────────────────────────────────────────────────────────────────────────────────
// ─── SEARCH LAYER (Books) ──────────────────────────────────────────────────────
// ────────────────────────────────────────────────────────────────────────────────

final googleBooksDatasourceProvider =
    Provider<GoogleBooksDatasource>((ref) {
  return GoogleBooksDatasource(ref.watch(dioProvider));
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl(ref.watch(googleBooksDatasourceProvider));
});

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

// ────────────────────────────────────────────────────────────────────────────────
// ─── FAVORITES LAYER ───────────────────────────────────────────────────────────
// ────────────────────────────────────────────────────────────────────────────────

final favoritesDatasourceProvider = Provider<FavoritesDatasource>((ref) {
  return FavoritesDatasource(ref.watch(supabaseClientProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesDatasourceProvider));
});

final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>((ref) {
  return GetFavoritesUseCase(ref.watch(favoritesRepositoryProvider));
});

final saveFavoriteUseCaseProvider = Provider<SaveFavoriteUseCase>((ref) {
  return SaveFavoriteUseCase(ref.watch(favoritesRepositoryProvider));
});

final removeFavoriteUseCaseProvider = Provider<RemoveFavoriteUseCase>((ref) {
  return RemoveFavoriteUseCase(ref.watch(favoritesRepositoryProvider));
});

// ────────────────────────────────────────────────────────────────────────────────
// ─── READING LIST LAYER ────────────────────────────────────────────────────────
// ────────────────────────────────────────────────────────────────────────────────

final readingListDatasourceProvider = Provider<ReadingListDatasource>((ref) {
  return ReadingListDatasource(ref.watch(supabaseClientProvider));
});

final readingListRepositoryProvider = Provider<ReadingListRepository>((ref) {
  return ReadingListRepositoryImpl(ref.watch(readingListDatasourceProvider));
});

final getReadingListUseCaseProvider = Provider<GetReadingListUseCase>((ref) {
  return GetReadingListUseCase(ref.watch(readingListRepositoryProvider));
});

final addToReadingListUseCaseProvider = Provider<AddToReadingListUseCase>((ref) {
  return AddToReadingListUseCase(ref.watch(readingListRepositoryProvider));
});

final removeFromReadingListUseCaseProvider = 
    Provider<RemoveFromReadingListUseCase>((ref) {
  return RemoveFromReadingListUseCase(ref.watch(readingListRepositoryProvider));
});
