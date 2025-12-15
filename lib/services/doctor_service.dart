
import 'package:medical_record_app/services/api_service.dart';

class DoctorService {
  // Obtenir le profil du docteur
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiService.get('doctors/profile');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le profil du docteur
  static Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? specialization,
    String? phoneNumber,
    String? hospital,
    String? address,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (fullName != null) data['full_name'] = fullName;
      if (specialization != null) data['specialization'] = specialization;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (hospital != null) data['hospital'] = hospital;
      if (address != null) data['address'] = address;
      
      final response = await ApiService.put('doctors/profile', data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques
  static Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await ApiService.get('doctors/statistics');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir tous les patients
  static Future<Map<String, dynamic>> getAllPatients() async {
    try {
      final response = await ApiService.get('doctors/patients');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des patients
  static Future<Map<String, dynamic>> searchPatients({
    required String searchTerm,
    String searchType = 'patient_name',
  }) async {
    try {
      final response = await ApiService.get('doctors/search', params: {
        'search_term': searchTerm,
        'search_type': searchType,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir tous les carnets médicaux
  static Future<Map<String, dynamic>> getAllMedicalRecords() async {
    try {
      final response = await ApiService.get('doctors/medical-records');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Changer le mot de passe
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await ApiService.put('doctors/change-password', {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}