import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBookByIdUseCase {
  final BookRepository _repo;
  GetBookByIdUseCase(this._repo);

  Future<Book> call(String bookId) => _repo.getBookById(bookId);
}