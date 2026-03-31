import '../../../search/domain/entities/book.dart';
import '../../../search/data/models/book_model.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/supabase_favorites_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesDatasource _datasource;
  FavoritesRepositoryImpl(this._datasource);

  @override
  Future<List<Book>> getFavorites() => _datasource.getFavorites();

  @override
  Future<bool> isFavorite(String bookId) =>
      _datasource.isFavorite(bookId);

  @override
  Future<void> addFavorite(Book book) =>
      _datasource.addFavorite(book as BookModel);

  @override
  Future<void> removeFavorite(String bookId) =>
      _datasource.removeFavorite(bookId);
}