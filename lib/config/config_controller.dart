
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier(true);
});


class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier(bool state) : super(state);
  void invertTheme() {
    state = !state;
  }
}
