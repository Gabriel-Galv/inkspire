import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_constants.dart';
import '../../../search/data/models/book_model.dart';

class ReadingListDatasource {
  final SupabaseClient _client;
  ReadingListDatasource(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<List<Map<String, dynamic>>> getReadingList() async {
    final data = await _client
        .from(SupabaseConstants.readingListTable)
        .select()
        .eq('user_id', _userId)
        .order('added_at', ascending: false);

    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<String?> getBookStatus(String bookId) async {
    final data = await _client
        .from(SupabaseConstants.readingListTable)
        .select('status')
        .eq('user_id', _userId)
        .eq('book_id', bookId)
        .maybeSingle();

    return data?['status'] as String?;
  }

  Future<void> addToReadingList(BookModel book, String status) async {
    await _client.from(SupabaseConstants.readingListTable).upsert({
      'user_id':       _userId,
      'book_id':       book.id,
      'title':         book.title,
      'authors':       book.authorsDisplay,
      'thumbnail_url': book.thumbnailUrl,
      'status':        status,
    });
  }

  Future<void> updateStatus(String bookId, String status) async {
    await _client
        .from(SupabaseConstants.readingListTable)
        .update({
          'status':     status,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', _userId)
        .eq('book_id', bookId);
  }

  Future<void> removeFromList(String bookId) async {
    await _client
        .from(SupabaseConstants.readingListTable)
        .delete()
        .eq('user_id', _userId)
        .eq('book_id', bookId);
  }
}