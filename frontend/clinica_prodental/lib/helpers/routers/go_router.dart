import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clinica_prodental/presentation/providers/features/auth/config/token_provider.dart';
import 'package:clinica_prodental/presentation/screens/screens.dart';

final authToken = TokenProvider();

final routerProvider = Provider<GoRouter>((ref) {
  //final auth = ref.read(authUserProviders.notifier);

  return GoRouter(
    refreshListenable: ref.watch(tokenProvider.notifier),

    redirect: (context, state) {
      final authState = ref.read(tokenProvider.notifier);
      final isLogin = state.matchedLocation == '/login';

      if (!authState.isLoggedIn && !isLogin) {
        return '/login';
      }

      if (authState.isLoggedIn && isLogin) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        name: LoginScreen.namePage,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: HomeScreen.namePage,
        builder: (_, _) => const HomeScreen(),
      ),

      GoRoute(
        path: '/calendar-reminders',
        name: CalendarReminders.namePage,
        builder: (_, _) => const CalendarReminders(),
      ),

      GoRoute(
        path: '/patient',
        name: PxScreen.namePage,
        builder: (_, _) => const PxScreen(),
      ),

      GoRoute(
        path: '/px-details/:idPx',
        name: PxDetailsScreen.namePage,
        builder: (context, state) {
          final String? id = state.pathParameters["idPx"];

          return PxDetailsScreen(idPx: id!);
        },
      ),

      GoRoute(
        path: '/citas',
        name: CitasScreen.namePage,
        builder: (_, _) => const CitasScreen(),
      ),
    ],
  );
});
