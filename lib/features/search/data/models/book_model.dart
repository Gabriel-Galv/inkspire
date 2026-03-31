import '../../domain/entities/book.dart';

// BookModel extiende Book añadiendo parseo de JSON (Google Books y Supabase).
// La domain layer solo conoce Book; la data layer trabaja con BookModel.
class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.authors,
    super.description,
    super.thumbnailUrl,
    super.publishedDate,
    super.publisher,
    super.pageCount,
    super.categories,
    super.averageRating,
    super.ratingsCount,
    super.language,
    super.previewLink,
    super.infoLink,
  });

  // ─── Google Books API ─────────────────────────────────────────────────────

  // Limpia HTML tags de descripciones si vienen con etiquetas
  static String _cleanDescription(String? text) {
    if (text == null || text.isEmpty) return '';
    // Elimina etiquetas HTML comunes
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')  // Remove HTML tags
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .trim();
  }

  factory BookModel.fromGoogleBooks(Map<String, dynamic> json) {
    final info   = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final images = info['imageLinks'] as Map<String, dynamic>? ?? {};

    // Intenta todas las opciones de imagen disponibles en Google Books API
    String? thumbnailUrl = images['extraLarge'] as String?
        ?? images['large'] as String?
        ?? images['medium'] as String?
        ?? images['small'] as String?
        ?? images['thumbnail'] as String?
        ?? images['smallThumbnail'] as String?;

    // Convierte HTTP a HTTPS si es necesario
    if (thumbnailUrl != null) {
      thumbnailUrl = thumbnailUrl.replaceAll('http://', 'https://');
    }

    // Intenta obtener descripción de múltiples fuentes
    String? description = info['description'] as String?;
    if ((description?.isEmpty ?? true)) {
      // Si no hay descripción, intenta obtener del previewText o synopsis
      description = info['previewText'] as String?;
    }
    if ((description?.isEmpty ?? true)) {
      description = info['synopsis'] as String?;
    }

    // Limpia HTML de la descripción si es necesario
    if (description != null) {
      description = _cleanDescription(description);
    }

    // Obtener previewLink - puede venir en volumeInfo o al nivel superior
    String? previewLink = info['previewLink'] as String?;
    if (previewLink == null && json.containsKey('previewLink')) {
      previewLink = json['previewLink'] as String?;
    }
    
    // Si no hay previewLink, intentar obtener webReaderLink del accessInfo
    if (previewLink == null) {
      final accessInfo = json['accessInfo'] as Map<String, dynamic>? ?? {};
      previewLink = accessInfo['webReaderLink'] as String?;
    }
    
    // Si aún no hay previewLink pero hay selfLink, crear una URL alternativa
    if ((previewLink?.isEmpty ?? true)) {
      final selfLink = json['selfLink'] as String? ?? '';
      final id = json['id'] as String? ?? '';

      // Intentar extraer ID del selfLink
      String bookId = id;
      if (bookId.isEmpty && selfLink.contains('volumes/')) {
        bookId = selfLink.split('volumes/').last;
      }

      // Si tenemos un ID válido, crear la URL de Google Books
      if (bookId.isNotEmpty) {
        // Usar el endpoint de libros de Google Books directamente
        previewLink = 'https://play.google.com/books/reader?id=$bookId';
      }
    }

    // Obtener infoLink (es más confiable que previewLink)
    String? infoLink = info['infoLink'] as String?;

    return BookModel(
      id:            json['id'] as String? ?? '',
      title:         info['title'] as String? ?? 'Sin título',
      authors:       (info['authors'] as List<dynamic>?)
                         ?.map((e) => e.toString())
                         .toList() ?? [],
      description:   description,
      thumbnailUrl:  thumbnailUrl,
      publishedDate: info['publishedDate'] as String?,
      publisher:     info['publisher'] as String?,
      pageCount:     info['pageCount'] as int?,
      categories:    (info['categories'] as List<dynamic>?)
                         ?.map((e) => e.toString())
                         .toList() ?? [],
      averageRating: (info['averageRating'] as num?)?.toDouble(),
      ratingsCount:  info['ratingsCount'] as int?,
      language:      info['language'] as String?,
      previewLink:   previewLink,
      infoLink:      infoLink,
    );
  }

  // ─── Supabase (favoritos / reading list) ─────────────────────────────────

  // Solo guardamos los campos mínimos para mostrar en listas
  // sin llamar a la API en cada render.
  Map<String, dynamic> toSupabaseMap(String userId) => {
    'user_id':       userId,
    'book_id':       id,
    'title':         title,
    'authors':       authorsDisplay,
    'thumbnail_url': thumbnailUrl,
  };

  factory BookModel.fromSupabase(Map<String, dynamic> json) {
    return BookModel(
      id:           json['book_id'] as String,
      title:        json['title']   as String,
      authors:      json['authors'] != null
                        ? [(json['authors'] as String)]
                        : [],
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }
}