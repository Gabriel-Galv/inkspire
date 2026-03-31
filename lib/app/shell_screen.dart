import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  static const _tabs = [
    _Tab(icon: Icons.home_rounded,     label: 'Inicio',    path: '/home'),
    _Tab(icon: Icons.search_rounded,   label: 'Buscar',    path: '/search'),
    _Tab(icon: Icons.favorite_rounded, label: 'Favoritos', path: '/favorites'),
    _Tab(icon: Icons.bookmark_rounded, label: 'Mi lista',  path: '/reading-list'),
    _Tab(icon: Icons.person_rounded,   label: 'Perfil',    path: '/profile'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(tabs: _tabs, currentIndex: current),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final List<_Tab> tabs;
  final int currentIndex;
  const _BottomNav({required this.tabs, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: InkColors.surfaceCard,
        border: Border(
          top: BorderSide(color: InkColors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: List.generate(tabs.length, (i) {
              final tab = tabs[i];
              final isSelected = i == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => context.go(tab.path),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? InkColors.primarySurface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.icon,
                          size: 22,
                          color: isSelected
                              ? InkColors.primary
                              : InkColors.textHint,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: InkTextStyles.labelSmall.copyWith(
                            color: isSelected
                                ? InkColors.primary
                                : InkColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  final IconData icon;
  final String label;
  final String path;
  const _Tab({required this.icon, required this.label, required this.path});
}