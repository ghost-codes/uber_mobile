import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_mobile/core/providers/appstateManager.dart';
import 'package:uber_mobile/core/providers/sessionManager.dart';
import 'package:uber_mobile/router/guestRouter.dart';
import 'package:uber_mobile/router/userRouter.dart';
import 'package:uber_mobile/utils/themeData.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);

    if (appState == AppState.Authenticated) {
      return const UserHost();
    }
    return const GuestHost();
  }
}

class GuestHost extends ConsumerStatefulWidget {
  const GuestHost({
    super.key,
  });

  @override
  ConsumerState<GuestHost> createState() => _GuestHostState();
}

class _GuestHostState extends ConsumerState<GuestHost> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(sessionProvider.notifier).stream;
      session.listen((event) {
        if (event == null) return;
        if (!event.isSignupComplete) guestRouter.pushNamed(GuestRoutes.userDetails);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: guestRouter,
    );
  }
}

class UserHost extends StatefulWidget {
  const UserHost({
    super.key,
  });

  @override
  State<UserHost> createState() => _UserHostState();
}

class _UserHostState extends State<UserHost> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: userRouter,
    );
  }
}
