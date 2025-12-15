// lib/services/patient_service.dart
import 'dart:convert';
import 'package:medical_record_app/models/patient.dart';
import 'package:medical_record_app/services/api_service.dart';

class PatientService {
  // Créer un patient
  static Future<Map<String, dynamic>> createPatient({
    required String fullName,
    required String? dateOfBirth,
    required String? gender,
    String? phoneNumber,
    String? email,
    String? emergencyContact,
    String? address,
    String? bloodGroup,
    String? allergies,
  }) async {
    try {
      final response = await ApiService.post('patients/create', {
        'full_name': fullName,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'phone_number': phoneNumber,
        'email': email,
        'emergency_contact': emergencyContact,
        'address': address,
        'medical_info': {
          'blood_group': bloodGroup,
          'allergies': allergies,
        },
      });

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher un patient par nom
  static Future<List<Patient>> searchPatientByName(String name) async {
  print('=== searchPatientByName appelée ===');
  print('Nom recherché: $name');
  
  try {
    print('Appel API: patients/search?full_name=$name');
    final response = await ApiService.get('patients/search', params: {
      'full_name': name,
    });
    
    print('Réponse API complète: $response');
    
    if (response['patients'] != null) {
      final patientsData = response['patients'] as List;
      print('Patients trouvés: ${patientsData.length}');
      
      final patients = patientsData.map((p) {
        print('Patient JSON: $p');
        return Patient.fromJson(p);
      }).toList();
      
      return patients;
    } else {
      print('Aucun patient dans la réponse');
      print('Structure de la réponse: ${response.keys}');
      return [];
    }
  } catch (e) {
    print('=== ERREUR searchPatientByName ===');
    print('Erreur: $e');
    print('StackTrace: ${e.toString()}');
    rethrow;
  }
}


  

  // Obtenir tous les patients du docteur
 static Future<List<Patient>> getDoctorPatients() async {
  try {
    print('=== Appel API getDoctorPatients ===');
    final response = await ApiService.get('patients/doctor/patients');
    
    print('Réponse API: $response');
    
    if (response['patients'] != null) {
      final patientsData = response['patients'] as List;
      print('Nombre de patients reçus: ${patientsData.length}');
      
      final patients = patientsData.map((p) {
        print('Patient: ${p.toString()}');
        return Patient.fromJson(p);
      }).toList();
      
      return patients;
    } else {
      print('Aucun patient dans la réponse');
      return [];
    }
  } catch (e) {
    print('=== ERREUR getDoctorPatients ===');
    print('Erreur: $e');
    print('StackTrace: ${e.toString()}');
    return [];
  }
}

  // Rechercher par empreinte digitale
  static Future<Patient?> searchByFingerprint(String fingerprintData) async {
    try {
      final response = await ApiService.post('patients/search/fingerprint', {
        'fingerprint_data': fingerprintData,
      });

      if (response['patient'] != null) {
        return Patient.fromJson(response['patient']);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher par code patient (pour docteur)
  static Future<List<Patient>> searchByCode(String code) async {
    try {
      final response = await ApiService.get('doctors/search', params: {
        'search_term': code,
        'search_type': 'patient_code',
      });

      if (response['results'] != null) {
        final results = response['results'] as List;
        return results.map((p) => Patient.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}