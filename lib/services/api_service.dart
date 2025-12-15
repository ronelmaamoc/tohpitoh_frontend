import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'https://e-carnet-backend.onrender.com/api'; 
  static String? _token;

  // Modifier pour accepter String?
  static void setToken(String? token) {
    _token = token;
  }

  static String? get token => _token;

  static Map<String, String> get headers {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  static Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        return {'message': response.body};
      }
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Une erreur est survenue');
      } catch (e) {
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    }
  }

  // Méthodes HTTP
  static Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? params}) async {
    String url = '$baseUrl/$endpoint';
    
    if (params != null) {
      final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
      url += '?$query';
    }
    
    if (kDebugMode) {
      print('GET: $url');
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final url = '$baseUrl/$endpoint';
    
    if (kDebugMode) {
      print('POST: $url');
      print('Data: $data');
    }
    
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(data),
    );
    
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final url = '$baseUrl/$endpoint';
    
    if (kDebugMode) {
      print('PUT: $url');
      print('Data: $data');
    }
    
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: json.encode(data),
    );
    
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = '$baseUrl/$endpoint';
    
    if (kDebugMode) {
      print('DELETE: $url');
    }
    
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );
    
    return _handleResponse(response);
  }
}