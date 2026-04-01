import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/shimmer_loader.dart';
import 'providers/search_provider.dart';
import 'widgets/search_result_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String initialQuery;
  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _ctrl;
  final _focus = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _ctrl  = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isEmpty) {
      // Abre teclado al entrar sin query
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _focus.requestFocus(),
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    // Busca a partir de 2 caracteres o cuando está vacío
    if (v.length >= 2 || v.isEmpty) {
      setState(() => _query = v.trim());
    }
  }

  void _onSubmitted(String v) => setState(() => _query = v.trim());

  void _clear() {
    _ctrl.clear();
    setState(() => _query = '');
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider(_query));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Barra de búsqueda ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: TextField(
                controller:    _ctrl,
                focusNode:     _focus,
                onChanged:     _onChanged,
                onSubmitted:   _onSubmitted,
                style:         InkTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Buscar libros, autores, géneros…',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: InkColors.textHint,
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded,
                              color: InkColors.textHint),
                          onPressed: _clear,
                        )
                      : null,
                ),
              ),
            ).animate().fadeIn().slideY(begin: -0.15),

            // ── Resultados ────────────────────────────────────────────────
            Expanded(
              child: _query.isEmpty
                  ? const _SuggestionsView()
                  : resultsAsync.when(
                      loading: () => const SearchSkeletonList(),
                      error: (_, __) => const _ErrorView(),
                      data: (books) {
                        if (books.isEmpty) {
                          return _EmptyResultsView(query: _query);
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          itemCount: books.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) => SearchResultTile(
                            book: books[i],
                          ).animate().fadeIn(
                                delay: Duration(milliseconds: 40 * i),
                              ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Vistas de estado ────────────────────────────────────────────────────────

class _SuggestionsView extends StatelessWidget {
  const _SuggestionsView();

  static const _suggestions = [
    'Harry Potter',
    'Gabriel García Márquez',
    'Ciencia ficción',
    'Psicología',
    'Historia universal',
    'Filosofía',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sugerencias', style: InkTextStyles.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((s) {
              return GestureDetector(
                onTap: () {
                  // Inyectamos el texto y buscamos
                  final state = context
                      .findAncestorStateOfType<_SearchScreenState>();
                  state?._ctrl.text = s;
                  state?.setState(() => state._query = s);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: InkColors.surfaceCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: InkColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up_rounded,
                          size: 14, color: InkColors.accent),
                      const SizedBox(width: 6),
                      Text(s, style: InkTextStyles.bodyMedium),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _EmptyResultsView extends StatelessWidget {
  final String query;
  const _EmptyResultsView({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 52, color: InkColors.textHint),
          const SizedBox(height: 12),
          Text(
            'Sin resultados para "$query"',
            style: InkTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Prueba con otro título o autor.',
            style: InkTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 52, color: InkColors.textHint),
          const SizedBox(height: 12),
          Text('Error de conexión.',
              style: InkTextStyles.bodyMedium),
          const SizedBox(height: 4),
          Text('Verifica tu internet e intenta de nuevo.',
              style: InkTextStyles.bodySmall),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(searchResultsProvider),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: InkColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}