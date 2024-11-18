import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica/config/constants/consts.dart';
import 'package:prueba_tecnica/presentation/providers/theme/index_page.riverpod.dart';
import 'package:prueba_tecnica/presentation/providers/theme/is_dark_theme_provider.dart';
import 'package:prueba_tecnica/presentation/views/favorites_view.dart';
import 'package:prueba_tecnica/presentation/views/home_view.dart';
import 'package:prueba_tecnica/presentation/views/reviews_view.dart';

const List<Widget> _pages = [
  HomeView(),
  ReviewsView(),
  SettingsView(),
];

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(isDarkThemeProvider);
    final indexPage = ref.watch(indexPageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(ApkConsts.apkName),
        actions: [
          SizedBox(width: 12),
          IconButton(
            onPressed: () => ref.read(isDarkThemeProvider.notifier).update(
              (state) {
                if (state == Consts.darkMode) {
                  return Consts.autoMode;
                } else if (state == Consts.lightMode) {
                  return Consts.darkMode;
                } else {
                  return Consts.lightMode;
                }
              },
            ),
            icon: Icon(
              (theme == Consts.darkMode)
                  ? Icons.dark_mode
                  : (theme == Consts.lightMode)
                      ? Icons.light_mode
                      : Icons.auto_mode,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: _pages[indexPage],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: indexPage,
          onTap: (index) => ref.read(indexPageProvider.notifier).state = index,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Productos"),
            BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add_check), label: "Revisados"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), label: "Favoritos")
          ]),
    );
  }
}
