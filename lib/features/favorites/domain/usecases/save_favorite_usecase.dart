import '../../../search/domain/entities/book.dart';
import '../repositories/favorites_repository.dart';

class SaveFavoriteUseCase {
  final FavoritesRepository _repo;
  SaveFavoriteUseCase(this._repo);

  Future<void> call(Book book) => _repo.addFavorite(book);
}