import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/book_model.dart';

class GoogleBooksDatasource {
  final Dio _dio;
  GoogleBooksDatasource(this._dio);

  Future<List<BookModel>> searchBooks(
    String query, {
    String? category,
    String? author,
    int startIndex = 0,
    int maxResults = ApiConstants.defaultMaxResults,
  }) async {
    var q = query.trim();
    if (q.isEmpty) return [];

    if (category != null && category.isNotEmpty) q += '+subject:$category';
    if (author   != null && author.isNotEmpty)   q += '+inauthor:$author';

    final params = <String, dynamic>{
      'q':          q,
      'maxResults': maxResults,
      'startIndex': startIndex,
      'orderBy':    'relevance',
    };
    if (ApiConstants.googleBooksApiKey.isNotEmpty) {
      params['key'] = ApiConstants.googleBooksApiKey;
    }

    final response = await _dio.get(
      '${ApiConstants.googleBooksBaseUrl}/volumes',
      queryParameters: params,
    );

    final items = response.data['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => BookModel.fromGoogleBooks(e as Map<String, dynamic>))
        .where((b) => b.id.isNotEmpty)
        .toList();
  }

  Future<BookModel> getBookById(String bookId) async {
    final params = <String, dynamic>{};
    if (ApiConstants.googleBooksApiKey.isNotEmpty) {
      params['key'] = ApiConstants.googleBooksApiKey;
    }

    final response = await _dio.get(
      '${ApiConstants.googleBooksBaseUrl}/volumes/$bookId',
      queryParameters: params,
    );

    // La respuesta de /volumes/$bookId es directamente el volume
    // No necesita envolver en 'items' como en la búsqueda
    final volumeData = response.data as Map<String, dynamic>;
    return BookModel.fromGoogleBooks(volumeData);
  }

  Future<List<BookModel>> getFeaturedBooks() async {
    return searchBooks(
      'bestsellers fiction',
      maxResults: ApiConstants.featuredMaxResults,
    );
  }

  Future<List<BookModel>> getBooksByCategory(String category) async {
    return searchBooks(
      category,
      category:   category,
      maxResults: ApiConstants.featuredMaxResults,
    );
  }
}