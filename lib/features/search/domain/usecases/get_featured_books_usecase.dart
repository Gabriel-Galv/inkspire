import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetFeaturedBooksUseCase {
  final BookRepository _repo;
  GetFeaturedBooksUseCase(this._repo);

  Future<List<Book>> call() => _repo.getFeaturedBooks();
}