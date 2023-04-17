import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_mobile/app.dart';
import 'package:uber_mobile/core/services/serviceLocator.dart';
import 'package:uber_mobile/firebase_options.dart';

void main() {
  unawaited(runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setupServices();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     systemNavigationBarColor: Colors.transparent));
    // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    runApp(const ProviderScope(child: App()));
  }, ((error, stack) => print(error))));
}
