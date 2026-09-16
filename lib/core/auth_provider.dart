import 'package:flutter/foundation.dart';
import 'api_client.dart';
import 'session_service.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  String? username;
  bool checking = true;

  /// Dipanggil sekali saat app start untuk cek apakah ada token
  /// tersimpan dari sesi sebelumnya (splash-screen logic).
  Future<void> restore() async {
    token = await SessionService.readToken();
    username = await SessionService.readUsername();
    checking = false;
    notifyListeners();
  }

  Future<void> login(String u, String p) async {
    final res = await ApiClient.login(u, p);
    token = res['token'] as String;
    username = (res['user']?['username'] as String?) ?? u;
    await SessionService.save(token!, username!);
    notifyListeners();
  }

  Future<void> logout() async {
    token = null;
    username = null;
    await SessionService.clear();
    notifyListeners();
  }

  bool get isLoggedIn => token != null;
}
