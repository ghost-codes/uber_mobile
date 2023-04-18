import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uber_mobile/ui/guest/signin.dart';
import 'package:uber_mobile/ui/guest/userDetails.dart';

class GuestRoutes {
  static const sigin = "sigin";
  static const userDetails = "user_details";
}

final guestRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  observers: [RouteObserver()],
  initialLocation: "/",
  // redirect: (ctx,state){
  //   sessionMonitor.

  //   return null;
  //   return null;},
  routes: [
    GoRoute(
      path: "/",
      name: GuestRoutes.sigin,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: "/user_details",
      name: GuestRoutes.userDetails,
      builder: (context, state) => UserDetailsPage(),
    )
  ],
);
