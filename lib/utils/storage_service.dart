import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  // Sauvegarder le token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Récupérer le token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Sauvegarder les données utilisateur
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, userData.toString());
  }

  // Récupérer les données utilisateur
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    
    if (userDataString != null) {
      try {
        // Simple parsing pour l'exemple
        // Dans une app réelle, utilisez json.decode
        return _parseUserData(userDataString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Effacer toutes les données
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Méthode pour parser les données utilisateur
  static Map<String, dynamic> _parseUserData(String data) {
    // Cette méthode est simplifiée
    // En réalité, vous devriez stocker en JSON
    final cleanedData = data
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll(' ', '');
    
    final Map<String, dynamic> result = {};
    final pairs = cleanedData.split(',');
    
    for (var pair in pairs) {
      final keyValue = pair.split(':');
      if (keyValue.length == 2) {
        final key = keyValue[0].trim();
        final value = keyValue[1].trim();
        result[key] = value;
      }
    }
    
    return result;
  }
}