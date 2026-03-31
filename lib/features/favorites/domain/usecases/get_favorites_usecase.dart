import '../../../search/domain/entities/book.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository _repo;
  GetFavoritesUseCase(this._repo);

  Future<List<Book>> call() => _repo.getFavorites();
}