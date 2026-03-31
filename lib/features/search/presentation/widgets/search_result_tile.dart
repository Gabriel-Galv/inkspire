import 'package:flutter/material.dart';

import '../../../../core/widgets/book_card.dart';
import '../../../search/domain/entities/book.dart';

// Alias semántico de BookListTile para la pantalla de búsqueda.
// Mantiene la nomenclatura de la estructura original.
class SearchResultTile extends StatelessWidget {
  final Book book;
  final Widget? trailing;

  const SearchResultTile({super.key, required this.book, this.trailing});

  @override
  Widget build(BuildContext context) {
    return BookListTile(book: book, trailing: trailing);
  }
}