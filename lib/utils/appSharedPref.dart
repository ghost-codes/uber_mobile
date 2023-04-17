import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPref {
  final SharedPreferences _pref;

  AppSharedPref({required SharedPreferences preferences}) : _pref = preferences;

  Future<bool> setAccessToken(String token) async => await _pref.setString("accessToken", token);
  Future<bool> setUser(String user) async => await _pref.setString("user", user);
  // Future<bool> setAccessToken(String token) async => await _pref.setString("accessToken", token);
  String? get accessToken {
    return _pref.getString("accessToken");
  }

  Map<String, dynamic>? get user {
    var result = _pref.getString("user");
    if (result == null) return null;

    return json.decode(result);
  }

  Future<bool> clearRecentSearch() async {
    return _pref.setStringList("recent_searches", []);
  }

  Future<bool> clear() async {
    return await _pref.clear();
  }
}
