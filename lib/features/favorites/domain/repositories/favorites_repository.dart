import '../../../search/domain/entities/book.dart';

abstract class FavoritesRepository {
  Future<List<Book>> getFavorites();
  Future<bool>       isFavorite(String bookId);
  Future<void>       addFavorite(Book book);
  Future<void>       removeFavorite(String bookId);
}