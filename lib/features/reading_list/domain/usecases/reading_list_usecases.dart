import '../../../search/domain/entities/book.dart';
import '../repositories/reading_list_repository.dart';

class GetReadingListUseCase {
  final ReadingListRepository _repo;
  GetReadingListUseCase(this._repo);
  Future<List<Map<String, dynamic>>> call() => _repo.getReadingList();
}

class GetBookStatusUseCase {
  final ReadingListRepository _repo;
  GetBookStatusUseCase(this._repo);
  Future<String?> call(String bookId) => _repo.getBookStatus(bookId);
}

class AddToReadingListUseCase {
  final ReadingListRepository _repo;
  AddToReadingListUseCase(this._repo);
  Future<void> call(Book book, String status) =>
      _repo.addToList(book, status);
}

class UpdateReadingStatusUseCase {
  final ReadingListRepository _repo;
  UpdateReadingStatusUseCase(this._repo);
  Future<void> call(String bookId, String status) =>
      _repo.updateStatus(bookId, status);
}

class RemoveFromReadingListUseCase {
  final ReadingListRepository _repo;
  RemoveFromReadingListUseCase(this._repo);
  Future<void> call(String bookId) => _repo.removeFromList(bookId);
}