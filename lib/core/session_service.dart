import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Menyimpan token JWT di penyimpanan aman perangkat (Keystore/Keychain).
///
/// Ini BUKAN PHP session bawaan. Validasi sesi tetap dilakukan di server
/// dengan memverifikasi tanda tangan token pada setiap request - lihat
/// api/jwt.php dan api/auth_middleware.php. Token ini murni disimpan
/// di sisi klien (kode Flutter), sesuai pendekatan yang diminta: session
/// ditangani di kode, bukan disimpan sebagai baris tabel di database.
class SessionService {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'klinik_bidan_token';
  static const _keyUsername = 'klinik_bidan_username';

  static Future<void> save(String token, String username) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyUsername, value: username);
  }

  static Future<String?> readToken() => _storage.read(key: _keyToken);
  static Future<String?> readUsername() => _storage.read(key: _keyUsername);

  static Future<void> clear() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyUsername);
  }
}
