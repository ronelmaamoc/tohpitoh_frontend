import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_record_app/providers/auth_provider.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 70, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Color(0xFF0A0E1C),
      body: Stack(
        children: [
          // Animated background gradient
          _buildAnimatedBackground(),
          
          // Floating particles
          ..._buildFloatingParticles(),
          
          SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    
                    // Animated Logo
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF0066FF),
                              Color(0xFF00D4FF),
                              Color(0xFF00FFA3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 0.6, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF0066FF).withOpacity(0.5),
                              blurRadius: 40,
                              spreadRadius: 8,
                            ),
                            BoxShadow(
                              color: Color(0xFF00FFA3).withOpacity(0.4),
                              blurRadius: 25,
                              offset: Offset(7, 7),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.medical_services_rounded,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Glassmorphic card with animation
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: _buildGlassCard(authProvider, size),
                    ),
                    
                    const Spacer(),
                    
                    Text(
                      '© 2024 MedSecure Healthcare Solutions',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard(AuthProvider authProvider, Size size) {
    return MouseRegion(
      onEnter: (_) {
        _animationController.forward(from: 0.8);
      },
      child: Container(
        width: size.width > 600 ? 520 : double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 50,
              spreadRadius: 8,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.18),
                    Colors.white.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.8,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(44.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              Color(0xFF0066FF),
                              Color(0xFF00D4FF),
                              Color(0xFF00FFA3),
                            ],
                            stops: [0.0, 0.6, 1.0],
                          ).createShader(bounds);
                        },
                        child: Text(
                          'Secure Access Portal',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Healthcare Professional Login',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 45),
                      
                      // Email field with improved design
                      _buildEnhancedTextField(
                        controller: _emailController,
                        label: 'Healthcare Email Address',
                        icon: Icons.email_rounded,
                        validator: (value) {
                          if (value!.isEmpty) return 'Email address is required';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      
                      // Password field with improved design
                      _buildEnhancedTextField(
                        controller: _passwordController,
                        label: 'Security Password',
                        icon: Icons.lock_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: Color(0xFF9CA3AF),
                              key: ValueKey(_obscurePassword),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Password is required';
                          if (value.length < 8) return 'Password must be at least 8 characters';
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 36),
                      
                      // Animated Login Button
                      _buildLoginButton(authProvider),
                      
                      const SizedBox(height: 36),
                      
                      // Alternative options
                      _buildAlternativeOptions(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      cursorColor: Color(0xFF0066FF),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Color(0xFF9CA3AF),
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xFF0066FF),
          fontWeight: FontWeight.w700,
        ),
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 18),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0066FF).withOpacity(0.25),
                Color(0xFF00FFA3).withOpacity(0.25),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: Color(0xFF9CA3AF),
            size: 24,
          ),
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.15),
            width: 1.8,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Color(0xFF0066FF),
            width: 2.2,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 20,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildLoginButton(AuthProvider authProvider) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: authProvider.isLoading ? [] : [
          BoxShadow(
            color: Color(0xFF0066FF).withOpacity(0.5),
            blurRadius: 25,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: authProvider.isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: authProvider.isLoading
                  ? [Color(0xFF4B5563), Color(0xFF374151)]
                  : [
                      Color(0xFF0066FF),
                      Color(0xFF00D4FF),
                      Color(0xFF00FFA3),
                    ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, 0.6, 1.0],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: authProvider.isLoading
                ? SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.security_rounded, size: 26),
                      const SizedBox(width: 14),
                      Text(
                        'Authenticate Access',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlternativeOptions() {
    return Column(
      children: [
        Divider(
          color: Colors.white.withOpacity(0.12),
          height: 36,
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAlternativeButton(
              icon: Icons.person_add_alt_1_rounded,
              label: 'Staff Registration',
              gradient: [Color(0xFF0066FF), Color(0xFF00D4FF)],
              route: '/doctor_register',
            ),
            _buildAlternativeButton(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Patient Access',
              gradient: [Color(0xFF00FFA3), Color(0xFF00CC82)],
              route: '/patient_access',
            ),
            _buildAlternativeButton(
              icon: Icons.help_rounded,
              label: 'Technical Support',
              gradient: [Color(0xFFFFD700), Color(0xFFFFB700)],
              route: '/support',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlternativeButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required String route,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.first.withOpacity(0.35),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1200),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.8,
          colors: [
            Color(0xFF1A1F3C),
            Color(0xFF0A0E1C),
            Color(0xFF02050F),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.4),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingParticles() {
    return List.generate(10, (index) {
      return Positioned(
        left: (index * 130) % 420,
        top: (index * 90) % 850,
        child: AnimatedContainer(
          duration: Duration(seconds: 4 + index),
          curve: Curves.easeInOut,
          width: 3 + index % 4,
          height: 3 + index % 4,
          decoration: BoxDecoration(
            color: index % 3 == 0
                ? Color(0xFF0066FF).withOpacity(0.7)
                : index % 3 == 1
                    ? Color(0xFF00FFA3).withOpacity(0.7)
                    : Color(0xFFFFD700).withOpacity(0.7),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: index % 3 == 0
                    ? Color(0xFF0066FF)
                    : index % 3 == 1
                        ? Color(0xFF00FFA3)
                        : Color(0xFFFFD700),
                blurRadius: 12,
                spreadRadius: 3,
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<AuthProvider>(context, listen: false).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } catch (e) {
        if (context.mounted) {
          _showErrorSnackBar(e.toString());
        }
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.white),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: EdgeInsets.all(22),
        elevation: 12,
        duration: Duration(seconds: 4),
      ),
    );
  }
}