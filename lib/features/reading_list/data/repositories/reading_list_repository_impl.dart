import '../../../search/domain/entities/book.dart';
import '../../../search/data/models/book_model.dart';
import '../../domain/repositories/reading_list_repository.dart';
import '../datasources/supabase_reading_list_datasource.dart';

class ReadingListRepositoryImpl implements ReadingListRepository {
  final ReadingListDatasource _datasource;
  ReadingListRepositoryImpl(this._datasource);

  @override
  Future<List<Map<String, dynamic>>> getReadingList() =>
      _datasource.getReadingList();

  @override
  Future<String?> getBookStatus(String bookId) =>
      _datasource.getBookStatus(bookId);

  @override
  Future<void> addToList(Book book, String status) =>
      _datasource.addToReadingList(book as BookModel, status);

  @override
  Future<void> updateStatus(String bookId, String status) =>
      _datasource.updateStatus(bookId, status);

  @override
  Future<void> removeFromList(String bookId) =>
      _datasource.removeFromList(bookId);
}
