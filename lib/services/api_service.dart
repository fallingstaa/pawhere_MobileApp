// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

// IMPORTANT: This is your live, deployed Firebase Function URL
const String _BASE_URL = 'https://us-central1-pawhereapp.cloudfunctions.net/api'; 

class ApiService {
  // Static variable to store the Traccar session cookie after successful login
  // This cookie is needed for all subsequent data requests (like getting positions)
  static String? _traccarSessionCookie; 

  // Endpoint: POST /v1/login
  // Authenticates the device/user credentials against the Traccar API via the proxy
  Future<Map<String, dynamic>> loginDevice({
    required String imei, 
    required String password,
  }) async {
    final url = Uri.parse('$_BASE_URL/v1/login');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          // The backend expects 'deviceId' and 'password'
          'deviceId': imei, 
          'password': password,
        }),
      );

      // Check if the Traccar login was successful (HTTP 200)
      if (response.statusCode == 200) {
        // 1. Store the session cookie for future requests
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          // Traccar returns a cookie containing JSESSIONID; we extract and store it.
          _traccarSessionCookie = cookies.split(',').firstWhere(
            (cookie) => cookie.contains('JSESSIONID'), 
            orElse: () => '',
          ).split(';').first.trim();
        }

        // 2. Parse the body to get the user/device details
        final responseData = json.decode(response.body);
        
        return {
          'success': true, 
          'message': 'Device successfully logged into Traccar.',
          'data': responseData, // Contains the Traccar User object
        };

      } else if (response.statusCode == 401) {
        return {
          'success': false, 
          'message': 'Invalid Device ID or Password. Status: ${response.statusCode}',
        };
      } else {
        return {
          'success': false, 
          'message': 'Traccar Login Failed. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Network or serialization error: $e');
      return {
        'success': false, 
        'message': 'Network Error: Could not connect to the server. Check internet and URL.',
      };
    }
  }

  // Example Endpoint: GET /v1/positions 
  // This is how you would fetch data using the stored session cookie later
  Future<Map<String, dynamic>> fetchDevicePositions() async {
    if (_traccarSessionCookie == null) {
       return {
          'success': false, 
          'message': 'Not authenticated. Please log in first.',
       };
    }

    final url = Uri.parse('$_BASE_URL/v1/positions');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': _traccarSessionCookie!, // Pass the stored session cookie
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
         return {
          'success': false, 
          'message': 'Failed to fetch positions. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Position fetch error: $e');
       return {
        'success': false, 
        'message': 'Network Error during position fetch.',
      };
    }
  }
}