import 'package:clinica_prodental/core/theme/app_colors.dart';
import 'package:clinica_prodental/helpers/routers/go_router.dart';
import 'package:clinica_prodental/presentation/providers/custom/preferences/dark_ligth_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: ContentMain());
  }
}

class ContentMain extends ConsumerStatefulWidget {
  const ContentMain({super.key});

  @override
  ConsumerState<ContentMain> createState() => _ContentMainState();
}

class _ContentMainState extends ConsumerState<ContentMain> {
  @override
  void initState() {
    super.initState();
    resizeWindow();
  }

  void resizeWindow() async {
    final Size size = Size(1500, 980);
    WidgetsFlutterBinding.ensureInitialized();
    await WindowManager.instance.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: size,
      center: true,
      minimumSize: Size(1100, 850),
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.center();

      await windowManager.setResizable(true);

      await windowManager.setTitle("Clinica Prodental");
      await windowManager.setSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkLightModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: isDark ? AppColors.darkTheme : AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
