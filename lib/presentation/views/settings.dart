import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prueba_tecnica/config/constants/consts.dart';
import 'package:prueba_tecnica/presentation/providers/theme/is_dark_theme_provider.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/circle_avatar_image_widget.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/theme_change.dart';

List<String> settings = ['Cambiar contraseña', 'Sobre Nosotros', 'Contáctenos'];

class SettingsView extends HookConsumerWidget {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final themeIsExpanded = useState(false);
    final activeNotifications = useState(false);
    final theme = ref.watch(isDarkThemeProvider);
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CircleAvatarImage(),
            SizedBox(
              height: 4,
            ),
            Text(
              'Luis Tomas Lezcano',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            ...List.generate(
                settings.length,
                (index) => ListTile(
                      title: Text(
                        settings[index],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    )),
            Divider(),
            ThemeExpansionTile(themeIsExpanded: themeIsExpanded, theme: theme),
            const Divider(),
            SwitchListTile.adaptive(
                onChanged: (value) => activeNotifications.value = value,
                value: activeNotifications.value,
                title: const Text('Notificaciones')),
            // const Divider(),
            SizedBox(
              height: 10,
            ),
            FilledButton(onPressed: () {}, child: const Text('Cerrar sesión'))
          ],
        ),
      ),
    ));
  }
}

class ThemeExpansionTile extends ConsumerWidget {
  const ThemeExpansionTile({
    super.key,
    required this.themeIsExpanded,
    required this.theme,
  });

  final ValueNotifier<bool> themeIsExpanded;
  final int theme;

  @override
  Widget build(BuildContext context, ref) {
    return ExpansionTile(
        shape: InputBorder.none,
        onExpansionChanged: (value) => themeIsExpanded.value = value,
        trailing: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: (themeIsExpanded.value)
              ? Tween(begin: 0.0, end: 1.0)
              : Tween(begin: 1.0, end: 0.0),
          builder: (BuildContext context, dynamic value, Widget? child) {
            return Transform.rotate(
              angle: pi * -value,
              child: child,
            );
          },
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        leading: Icon(
          (theme == Consts.darkMode)
              ? Icons.dark_mode
              : (theme == Consts.lightMode)
                  ? Icons.light_mode
                  : Icons.auto_mode,
        ),
        title: Text(
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            "Tema"),
        children: [
          ThemeChangeWidget(
            icon: Icons.light_mode,
            label: 'Modo claro',
            onPressed: () =>
                ref.read(isDarkThemeProvider.notifier).state = Consts.lightMode,
          ),
          ThemeChangeWidget(
            icon: Icons.dark_mode_outlined,
            label: "Modo oscuro",
            onPressed: () =>
                ref.read(isDarkThemeProvider.notifier).state = Consts.darkMode,
          ),
          ThemeChangeWidget(
            icon: Icons.auto_mode,
            label: "Modo automático",
            onPressed: () =>
                ref.read(isDarkThemeProvider.notifier).state = Consts.autoMode,
          ),
        ]);
  }
}
