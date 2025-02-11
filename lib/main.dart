import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'core/inject/inject.dart';
import 'features/board_page/presentation/ui/board_page_ui.dart';
void main() {
  init();
  runApp(
    FluentApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    ),
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const BoardPageUi();
      },
    ),
  ],
);
