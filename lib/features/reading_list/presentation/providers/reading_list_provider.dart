import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/supabase_reading_list_datasource.dart';
import '../../data/repositories/reading_list_repository_impl.dart';
import '../../domain/repositories/reading_list_repository.dart';
import '../../domain/usecases/reading_list_usecases.dart';

// ─── Datasource & Repository ──────────────────────────────────────────────────

final readingListDatasourceProvider =
    Provider<ReadingListDatasource>((ref) {
  return ReadingListDatasource(Supabase.instance.client);
});

final readingListRepositoryProvider =
    Provider<ReadingListRepository>((ref) {
  return ReadingListRepositoryImpl(
    ref.watch(readingListDatasourceProvider),
  );
});

// ─── Use Cases ────────────────────────────────────────────────────────────────

final getReadingListUseCaseProvider =
    Provider<GetReadingListUseCase>((ref) {
  return GetReadingListUseCase(ref.watch(readingListRepositoryProvider));
});

final getBookStatusUseCaseProvider =
    Provider<GetBookStatusUseCase>((ref) {
  return GetBookStatusUseCase(ref.watch(readingListRepositoryProvider));
});

final addToReadingListUseCaseProvider =
    Provider<AddToReadingListUseCase>((ref) {
  return AddToReadingListUseCase(ref.watch(readingListRepositoryProvider));
});

final updateReadingStatusUseCaseProvider =
    Provider<UpdateReadingStatusUseCase>((ref) {
  return UpdateReadingStatusUseCase(
    ref.watch(readingListRepositoryProvider),
  );
});

final removeFromReadingListUseCaseProvider =
    Provider<RemoveFromReadingListUseCase>((ref) {
  return RemoveFromReadingListUseCase(
    ref.watch(readingListRepositoryProvider),
  );
});

// ─── State Providers ──────────────────────────────────────────────────────────

// Lista completa del usuario
final readingListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  if (!ref.watch(isLoggedInProvider)) return [];
  return ref.watch(getReadingListUseCaseProvider).call();
});

// Estado de un libro específico — usado en book_detail
final bookStatusProvider =
    FutureProvider.family<String?, String>((ref, bookId) async {
  if (!ref.watch(isLoggedInProvider)) return null;
  return ref.watch(getBookStatusUseCaseProvider).call(bookId);
});