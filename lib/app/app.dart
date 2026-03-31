import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class InkspireApp extends ConsumerWidget {
  const InkspireApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Inkspire',
      debugShowCheckedModeBanner: false,
      theme: InkTheme.light,
      routerConfig: router,
    );
  }
}