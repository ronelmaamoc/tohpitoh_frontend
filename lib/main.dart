import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_record_app/providers/auth_provider.dart';
import 'package:medical_record_app/pages/auth/splash_screen.dart';
import 'package:medical_record_app/pages/auth/login_screen.dart';
import 'package:medical_record_app/pages/auth/doctor_register_page.dart';
import 'package:medical_record_app/pages/doctor/doctor_dashboard.dart';
import 'package:medical_record_app/pages/doctor/create_patient_page.dart';
import 'package:medical_record_app/pages/doctor/search_patient_page.dart';
import 'package:medical_record_app/pages/doctor/patient_record_page.dart';
import 'package:medical_record_app/pages/doctor/acces_medical_record.dart';
import 'package:medical_record_app/models/patient.dart';

void main() {
  runApp(const MediCareApp());
}

class MediCareApp extends StatelessWidget {
  const MediCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'MediCare Pro',
        // theme: ThemeData(
        //   useMaterial3: true,
        //   colorScheme: ColorScheme.fromSeed(
        //     seedColor: const Color(0xFF1A73E8),
        //     brightness: Brightness.light,
        //   ),
        //   fontFamily: 'Inter',
        // ),
        theme: ThemeData(
  primaryColor: Color(0xFF6366F1),
  primaryColorDark: Color(0xFF4F46E5),
  primaryColorLight: Color(0xFFA5B4FC),
  scaffoldBackgroundColor: Color(0xFFF8FAFC),
  fontFamily: 'Inter',
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.indigo,
    accentColor: Color(0xFFEC4899),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white.withOpacity(0.95),
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF4B5563)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  ),
),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const LoginPage(),
          '/doctor_register': (context) => const DoctorRegisterPage(),
          '/doctor_dashboard': (context) => const DoctorDashboard(),
          '/create_patient': (context) => const CreatePatientPage(),
          '/search_patient': (context) => const SearchPatientPage(),
          '/access_medical_record': (context) => const AccessMedicalRecordPage(),
          '/patient_record': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            
            if (args is Patient) {
              return PatientRecordPage(patient: args);
            } else if (args is Map<String, dynamic> && args['patient'] is Patient) {
              return PatientRecordPage(patient: args['patient'] as Patient);
            } else {
              // Fallback ou page d'erreur
              return Scaffold(
                appBar: AppBar(title: const Text('Erreur')),
                body: const Center(child: Text('Patient non trouvé')),
              );
            }
          },
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuth();
    
    // Charger le profil si authentifié
    if (authProvider.isAuthenticated) {
      await authProvider.loadDoctorProfile();
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const DoctorDashboard();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}