import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawhere/models/position_model.dart';

class TraccarService {
  static const String _baseUrl = 'https://api-wm2ydm3q6a-uc.a.run.app/api/v1';

  static final TraccarService _instance = TraccarService._internal();
  factory TraccarService() => _instance;
  TraccarService._internal();

  Future<String?> _getIdToken() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
    return await user?.getIdToken();
  }

  Future<List<Position>> fetchDevicePositions() async {
    final token = await _getIdToken();
    if (token == null) {
      print('No Firebase ID token available.');
      return [];
    }
    final url = Uri.parse('$_baseUrl/positions');
    try {
      final resp = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));
      if (resp.statusCode == 200) {
        final List<dynamic> list = json.decode(resp.body);
        return list.map((e) => Position.fromJson(e)).toList();
      }
      print('Positions fetch failed: ${resp.statusCode} ${resp.body}');
      return [];
    } catch (e) {
      print('Positions fetch error: $e');
      return [];
    }
  }
}
