import '../entities/book.dart';
import '../repositories/book_repository.dart';

class SearchBooksUseCase {
  final BookRepository _repo;
  SearchBooksUseCase(this._repo);

  Future<List<Book>> call(
    String query, {
    String? category,
    String? author,
    int startIndex = 0,
  }) =>
      _repo.searchBooks(
        query,
        category:   category,
        author:     author,
        startIndex: startIndex,
      );
}