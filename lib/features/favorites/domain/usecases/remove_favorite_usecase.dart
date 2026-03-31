import '../repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  final FavoritesRepository _repo;
  RemoveFavoriteUseCase(this._repo);

  Future<void> call(String bookId) => _repo.removeFavorite(bookId);
}