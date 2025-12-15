import 'package:flutter/foundation.dart';
import 'package:medical_record_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Vérifier l'authentification au démarrage
  Future<void> checkAuth() async {
    // Ne pas appeler notifyListeners() au début si on est déjà en build
    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      
      if (isLoggedIn) {
        final isValid = await AuthService.validateToken();
        
        if (isValid) {
          _isAuthenticated = true;
          _userData = await AuthService.getCurrentDoctor();
        } else {
          await AuthService.logout();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Auth check error: $e');
      }
    }
  }

  // Inscription
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    required String licenseNumber,
    required String specialization,
    String? phoneNumber,
    String? hospital,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.registerDoctor(
        email: email,
        password: password,
        fullName: fullName,
        licenseNumber: licenseNumber,
        specialization: specialization,
       
      );

      _isAuthenticated = true;
      _userData = response['doctor'];
      
      return response;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Connexion
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.loginDoctor(
        email: email,
        password: password,
      );

      _isAuthenticated = true;
      _userData = response['doctor'];
      
      return response;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDoctorProfile() async {
  _isLoading = true;
  notifyListeners();

  try {
    final profile = await AuthService.getDoctorProfile();
    _userData = profile;
    notifyListeners();
  } catch (e) {
    if (kDebugMode) {
      print('Erreur chargement profil: $e');
    }
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Déconnexion
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
      _isAuthenticated = false;
      _userData = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Effacer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Mettre à jour les données utilisateur
  void updateUserData(Map<String, dynamic> newData) {
    _userData = {...?_userData, ...newData};
    notifyListeners();
  }
}