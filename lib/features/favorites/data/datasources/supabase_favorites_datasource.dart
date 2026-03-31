import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_constants.dart';
import '../../../search/data/models/book_model.dart';

class FavoritesDatasource {
  final SupabaseClient _client;
  FavoritesDatasource(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<List<BookModel>> getFavorites() async {
    final data = await _client
        .from(SupabaseConstants.favoritesTable)
        .select()
        .eq('user_id', _userId)
        .order('saved_at', ascending: false);

    return (data as List)
        .map((e) => BookModel.fromSupabase(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> isFavorite(String bookId) async {
    final data = await _client
        .from(SupabaseConstants.favoritesTable)
        .select('id')
        .eq('user_id', _userId)
        .eq('book_id', bookId)
        .maybeSingle();

    return data != null;
  }

  Future<void> addFavorite(BookModel book) async {
    await _client
        .from(SupabaseConstants.favoritesTable)
        .upsert(book.toSupabaseMap(_userId));
  }

  Future<void> removeFavorite(String bookId) async {
    await _client
        .from(SupabaseConstants.favoritesTable)
        .delete()
        .eq('user_id', _userId)
        .eq('book_id', bookId);
  }
}