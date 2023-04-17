import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uber_mobile/ui/user/home.dart';

class UserRoutes {
  static const home = "home";
}

final userRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  observers: [RouteObserver()],
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      name: UserRoutes.home,
      builder: (context, state) => const HomePage(),
    )
  ],
);
