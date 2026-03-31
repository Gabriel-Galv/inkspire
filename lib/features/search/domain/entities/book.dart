class Book {
  final String       id;
  final String       title;
  final List<String> authors;
  final String?      description;
  final String?      thumbnailUrl;
  final String?      publishedDate;
  final String?      publisher;
  final int?         pageCount;
  final List<String> categories;
  final double?      averageRating;
  final int?         ratingsCount;
  final String?      language;
  final String?      previewLink;
  final String?      infoLink;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.thumbnailUrl,
    this.publishedDate,
    this.publisher,
    this.pageCount,
    this.categories = const [],
    this.averageRating,
    this.ratingsCount,
    this.language,
    this.previewLink,
    this.infoLink,
  });

  // ─── Computed properties ──────────────────────────────────────────────────

  String get authorsDisplay =>
      authors.isEmpty ? 'Autor desconocido' : authors.join(', ');

  String get yearDisplay {
    if (publishedDate == null || publishedDate!.isEmpty) return '';
    return publishedDate!.length >= 4
        ? publishedDate!.substring(0, 4)
        : publishedDate!;
  }

  // Convierte thumbnail a mayor resolución (zoom=1 → zoom=2)
  String? get highResThumbnail {
    if (thumbnailUrl == null) return null;
    return thumbnailUrl!
        .replaceAll('http://', 'https://')
        .replaceAll('zoom=1', 'zoom=2');
  }

  Book copyWith({
    String?       id,
    String?       title,
    List<String>? authors,
    String?       description,
    String?       thumbnailUrl,
    String?       publishedDate,
    String?       publisher,
    int?          pageCount,
    List<String>? categories,
    double?       averageRating,
    int?          ratingsCount,
    String?       language,
    String?       previewLink,
    String?       infoLink,
  }) {
    return Book(
      id:            id            ?? this.id,
      title:         title         ?? this.title,
      authors:       authors       ?? this.authors,
      description:   description   ?? this.description,
      thumbnailUrl:  thumbnailUrl  ?? this.thumbnailUrl,
      publishedDate: publishedDate ?? this.publishedDate,
      publisher:     publisher     ?? this.publisher,
      pageCount:     pageCount     ?? this.pageCount,
      categories:    categories    ?? this.categories,
      averageRating: averageRating ?? this.averageRating,
      ratingsCount:  ratingsCount  ?? this.ratingsCount,
      language:      language      ?? this.language,
      previewLink:   previewLink   ?? this.previewLink,
      infoLink:      infoLink      ?? this.infoLink,
    );
  }

  @override
  bool operator ==(Object other) => other is Book && other.id == id;

  @override
  int get hashCode => id.hashCode;
}