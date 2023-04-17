import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_mobile/core/models/session.dart';
import 'package:uber_mobile/core/providers/sessionManager.dart';

enum AppState { Authenticated, Unauthenticated }

class AppStateManager extends StateNotifier<AppState> {
  AppStateManager(super.state);

  Future<void> initialize() async {
    // Check shared preferences for session token

    // if exists set appstate to auth
    // else unauth
  }

  Future<void> update(AppState appState) async {
    state = appState;
  }
}

final appStateProvider = StateNotifierProvider((ref) {
  final seshProvider = ref.watch<Session?>(sessionProvider);

  final appStateManager = AppStateManager(AppState.Unauthenticated);
  if (seshProvider == null || !seshProvider.isSignupComplete) {
    // if (seshProvider?.isSignupComplete ?? true) {
    appStateManager.update(AppState.Unauthenticated);
  } else {
    appStateManager.update(AppState.Authenticated);
  }

  return appStateManager;
});
