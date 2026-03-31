import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> searchBooks(
    String query, {
    String? category,
    String? author,
    int startIndex,
  });

  Future<Book> getBookById(String bookId);
  Future<List<Book>> getFeaturedBooks();
  Future<List<Book>> getBooksByCategory(String category);
}