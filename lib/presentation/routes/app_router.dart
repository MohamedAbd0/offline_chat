import 'package:go_router/go_router.dart';
import '../pages/main_page.dart';
import '../pages/settings_page.dart';

class AppRouter {
  static const String home = '/';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(path: home, builder: (context, state) => const MainPage()),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
