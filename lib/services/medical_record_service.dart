// lib/services/medical_record_service.dart
import 'package:medical_record_app/services/api_service.dart';

class MedicalRecordService {
  // Accéder à un carnet médical avec le code (public)
  static Future<Map<String, dynamic>> accessMedicalRecord(String recordCode) async {
    try {
      final response = await ApiService.post('medical-records/access', {
        'record_code': recordCode,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }


  // Rechercher un carnet médical par empreinte digitale (docteur seulement)
  static Future<Map<String, dynamic>> searchByFingerprint(String fingerprintData) async {
    try {
      final response = await ApiService.post('medical-records/fingerprint/search', {
        'fingerprint_data': fingerprintData,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }



  // Obtenir tous les carnets médicaux du docteur
  static Future<List<dynamic>> getDoctorMedicalRecords() async {
    try {
      final response = await ApiService.get('doctors/medical-records');
      return response['medical_records'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // Ajouter une consultation
  static Future<void> addConsultation({
    required String medicalRecordId,
    required String consultationDate,
    required String symptoms,
    required String diagnosis,
    String? prescription,
    String? notes,
  }) async {
    try {
      await ApiService.post('medical-records/$medicalRecordId/consultations', {
        'consultation_date': consultationDate,
        'symptoms': symptoms,
        'diagnosis': diagnosis,
        'prescription': prescription,
        'notes': notes,
      });
    } catch (e) {
      rethrow;
    }
  }
}