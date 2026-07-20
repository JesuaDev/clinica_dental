import 'package:flutter_riverpod/legacy.dart';

final darkLightModeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  void toggleMode() {
    state = !state;
  }
}
