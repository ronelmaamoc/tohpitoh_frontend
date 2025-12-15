import 'package:medical_record_app/services/api_service.dart';
import 'package:medical_record_app/utils/storage_service.dart';

class AuthService {
  // Inscription d'un docteur
  static Future<Map<String, dynamic>> registerDoctor({
    required String email,
    required String password,
    required String fullName,
    required String licenseNumber,
    required String specialization,
    
  }) async {
    try {
      // Créer un Map avec les données
      final Map<String, dynamic> data = {
        'email': email,
        'password': password,
        'full_name': fullName,
        'license_number': licenseNumber,
        'specialization': specialization,
      };

      // Ajouter les champs optionnels seulement s'ils ne sont pas null
     

      final response = await ApiService.post('auth/register/doctor', data);

      // Sauvegarder le token
      if (response['token'] != null) {
        await StorageService.saveToken(response['token'] as String);
        ApiService.setToken(response['token'] as String);
        
        // Sauvegarder les infos du docteur
        if (response['doctor'] != null) {
          await StorageService.saveUserData(response['doctor'] as Map<String, dynamic>);
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Connexion d'un docteur
  static Future<Map<String, dynamic>> loginDoctor({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('auth/login/doctor', {
        'email': email,
        'password': password,
      });

      // Sauvegarder le token
      if (response['token'] != null) {
        await StorageService.saveToken(response['token'] as String);
        ApiService.setToken(response['token'] as String);
        
        // Sauvegarder les infos du docteur
        if (response['doctor'] != null) {
          await StorageService.saveUserData(response['doctor'] as Map<String, dynamic>);
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  static Future<void> logout() async {
    await StorageService.clearAll();
    ApiService.setToken(null);
  }

  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final token = await StorageService.getToken();
    if (token != null) {
      ApiService.setToken(token);
      return true;
    }
    return false;
  }

  // Récupérer les infos du docteur connecté
  static Future<Map<String, dynamic>?> getCurrentDoctor() async {
    try {
      final userData = await StorageService.getUserData();
      return userData;
    } catch (e) {
      return null;
    }
  }

static Future<Map<String, dynamic>> getDoctorProfile() async {
  try {
    final response = await ApiService.get('doctors/profile');
    if (response['doctor'] != null) {
      // Mettre à jour les données dans le stockage
      await StorageService.saveUserData(response['doctor'] as Map<String, dynamic>);
      return response['doctor'] as Map<String, dynamic>;
    }
    throw Exception('Aucun profil trouvé');
  } catch (e) {
    rethrow;
  }
}  

  // Vérifier la validité du token
  static Future<bool> validateToken() async {
    try {
      final response = await ApiService.get('doctors/profile');
      return response['doctor'] != null;
    } catch (e) {
      return false;
    }
  }
}