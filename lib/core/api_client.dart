import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:klinik_bidan/models/pasien.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiClient {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost/klinik_bidan_api';

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/klinik_bidan_api';
    }

    return 'http://localhost/klinik_bidan_api';
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) {
      throw ApiException(body['message'] ?? 'Login gagal');
    }
    return body;
  }

  static Future<List<Pasien>> getPasienList(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/pasien_list.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 401) {
      throw ApiException('Sesi berakhir, silakan login ulang');
    }

    if (res.statusCode != 200) {
      final body = jsonDecode(res.body);
      throw ApiException(body['message'] ?? 'Gagal memuat data pasien');
    }

    final list = jsonDecode(res.body) as List;
    return list.map((e) => Pasien.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> createPasien(String token, Pasien p) async {
    final res = await http.post(
      Uri.parse('$baseUrl/pasien_create.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(p.toJson()),
    );

    // Menerima status 200 atau 201
    if (res.statusCode != 200 && res.statusCode != 201) {
      final body = jsonDecode(res.body);
      throw ApiException(body['message'] ?? 'Gagal menambah pasien');
    }
  }

  static Future<void> updatePasien(String token, Pasien p) async {
    final res = await http.put(
      Uri.parse('$baseUrl/pasien_update.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(p.toJson()),
    );

    if (res.statusCode != 200) {
      final body = jsonDecode(res.body);
      throw ApiException(body['message'] ?? 'Gagal mengubah data pasien');
    }
  }

  static Future<void> deletePasien(String token, int id) async {
    final res = await http.post(
      Uri.parse('$baseUrl/pasien_delete.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'id': id}),
    );

    if (res.statusCode != 200) {
      final body = jsonDecode(res.body);
      throw ApiException(body['message'] ?? 'Gagal menghapus data pasien');
    }
  }
}