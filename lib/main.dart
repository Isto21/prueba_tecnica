import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica/config/constants/consts.dart';
import 'package:prueba_tecnica/config/router/router.dart';
import 'package:prueba_tecnica/config/theme/app_theme.dart';
import 'package:prueba_tecnica/presentation/providers/theme/is_dark_theme_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final brightness = ref.watch(isDarkThemeProvider);
        return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: ApkConsts.apkName,
            theme: AppTheme().themeLight(),
            darkTheme: AppTheme().themeDark(),
            themeMode: (brightness == Consts.darkMode)
                ? ThemeMode.dark
                : (brightness == Consts.lightMode)
                    ? ThemeMode.light
                    : ThemeMode.system,
            routerConfig: appRouter);
      },
    );
  }
}
