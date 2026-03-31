import '../../../search/domain/entities/book.dart';

abstract class ReadingListRepository {
  Future<List<Map<String, dynamic>>> getReadingList();
  Future<String?>                    getBookStatus(String bookId);
  Future<void>                       addToList(Book book, String status);
  Future<void>                       updateStatus(String bookId, String status);
  Future<void>                       removeFromList(String bookId);
}