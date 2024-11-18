import 'package:prueba_tecnica/config/constants/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkThemeProvider = StateProvider<int>((ref) {
  return Consts.lightMode;
});
