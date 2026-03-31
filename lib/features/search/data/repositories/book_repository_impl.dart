import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/google_books_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final GoogleBooksDatasource _datasource;
  BookRepositoryImpl(this._datasource);

  @override
  Future<List<Book>> searchBooks(
    String query, {
    String? category,
    String? author,
    int startIndex = 0,
  }) =>
      _datasource.searchBooks(
        query,
        category:   category,
        author:     author,
        startIndex: startIndex,
      );

  @override
  Future<Book> getBookById(String bookId) =>
      _datasource.getBookById(bookId);

  @override
  Future<List<Book>> getFeaturedBooks() =>
      _datasource.getFeaturedBooks();

  @override
  Future<List<Book>> getBooksByCategory(String category) =>
      _datasource.getBooksByCategory(category);
}