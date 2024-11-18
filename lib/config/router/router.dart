import 'package:prueba_tecnica/presentation/pages/pages.dart';
import 'package:go_router/go_router.dart';

import 'router_path.dart';
import 'router_transition.dart';

final appRouter = GoRouter(
  initialLocation: RouterPath.HOME_PAGE,
  routes: [
    GoRoute(
      path: RouterPath.HOME_PAGE,
      pageBuilder: (context, state) => RouterTransition.fadeTransitionPage(
          key: state.pageKey, child: const HomePage()),
    ),
  ],
);
