import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final tokenProvider = ChangeNotifierProvider((ref) {
  return TokenProvider();
});

class TokenProvider extends ChangeNotifier {
  final storage = FlutterSecureStorage();

  String? token;

  TokenProvider() {
    loadToken();
  }

  Future<void> loadToken() async {
    token = await storage.read(key: 'token');
    notifyListeners();
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
    token = null;
    notifyListeners();
  }

  bool get isLoggedIn => token != null;
}
