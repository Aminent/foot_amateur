import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import 'loading_screen.dart';

class LoginPage extends StatefulWidget {
  final AuthController auth;
  const LoginPage({super.key, required this.auth});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    // Pré-remplit le dernier email utilisé
    SharedPreferences.getInstance().then((p) {
      final saved = p.getString(_savedEmailKey);
      final remember = p.getBool(_rememberKey) ?? true;
      if (!mounted) return;
      setState(() => _remember = remember);
      if (remember && saved != null && _email.text.isEmpty) _email.text = saved;
    });
  }

  static const _savedEmailKey = 'last_login_email';
  static const _rememberKey = 'remember_login_email';
  bool _remember = true;

  @override
  void dispose() {
    _animationController.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Add timeout to prevent infinite loading
      final success = await widget.auth.login(_email.text.trim(), _password.text)
          .timeout(const Duration(seconds: 30));
      if (success == true) {
        final p = await SharedPreferences.getInstance();
        await p.setBool(_rememberKey, _remember);
        if (_remember) {
          await p.setString(_savedEmailKey, _email.text.trim());
        } else {
          await p.remove(_savedEmailKey);
        }
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Navigation is handled automatically by HomeRouter when auth state changes
      // No need to manually navigate here
    } catch (e) {
      print('Login error: $e'); // Debug log
        
      // Show specific error message
      String errorMessage = 'Une erreur est survenue';
      if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Délai de connexion dépassé. Vérifiez votre connexion.';
      } else if (widget.auth.error != null) {
        errorMessage = widget.auth.error!;
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }


  // ── UI (design de l'APK du 15/10) ──────────────────────────────────────────
  bool _obscure = true;

  InputDecoration _glassField(String hint, IconData icon, {Widget? suffix}) {
    OutlineInputBorder border(Color c, [double w = 1.2]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 17),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 18, right: 12),
        child: Icon(icon, color: Colors.white.withOpacity(0.85), size: 24),
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.07),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      border: border(Colors.white.withOpacity(0.28)),
      enabledBorder: border(Colors.white.withOpacity(0.28)),
      focusedBorder: border(const Color(0xFF6C63FF), 1.8),
      errorBorder: border(const Color(0xFFEF4444), 1.8),
      focusedErrorBorder: border(const Color(0xFFEF4444), 1.8),
      errorStyle: const TextStyle(color: Color(0xFFF5A623), fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.auth.loading) {
      return LoadingScreen(message: 'Connexion en cours...', showBackground: true);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
      backgroundColor: const Color(0xFF0B1424),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/bg_foot2.png'), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.35), Colors.black.withOpacity(0.15), Colors.black.withOpacity(0.45)],
            ),
          ),
          child: AnimatedBuilder(
            animation: widget.auth,
            builder: (context, _) => Center(
              child: SingleChildScrollView(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 144,
                            height: 144,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A4150).withOpacity(0.92),
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 10))],
                            ),
                            child: Lottie.asset('assets/footballer.json', height: 116, width: 116),
                          ),
                          const SizedBox(height: 36),
                          const Text(
                            'Foot Amateur',
                            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: 0.3),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Connectez-vous à votre compte',
                            style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 36),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(26, 30, 26, 28),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white.withOpacity(0.30), width: 1.2),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(children: [
                                    TextFormField(
                                      controller: _email,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(color: Colors.white, fontSize: 17),
                                      cursorColor: const Color(0xFFF5A623),
                                      decoration: _glassField('Email', Icons.person_outline),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) return 'Email requis';
                                        if (!v.contains('@')) return 'Email invalide';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    TextFormField(
                                      controller: _password,
                                      obscureText: _obscure,
                                      onFieldSubmitted: (_) => _submit(),
                                      style: const TextStyle(color: Colors.white, fontSize: 17),
                                      cursorColor: const Color(0xFFF5A623),
                                      decoration: _glassField(
                                        'Mot de passe',
                                        Icons.lock_outline,
                                        suffix: IconButton(
                                          onPressed: () => setState(() => _obscure = !_obscure),
                                          icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                              color: Colors.white.withOpacity(0.7)),
                                        ),
                                      ),
                                      validator: (v) => (v == null || v.isEmpty) ? 'Mot de passe requis' : null,
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => setState(() => _remember = !_remember),
                                      child: Row(children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                            value: _remember,
                                            onChanged: (v) => setState(() => _remember = v ?? false),
                                            activeColor: const Color(0xFF6C63FF),
                                            checkColor: Colors.white,
                                            side: BorderSide(color: Colors.white.withOpacity(0.7), width: 1.5),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text('Se souvenir de moi',
                                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15)),
                                      ]),
                                    ),
                                    const SizedBox(height: 20),
                                    if (widget.auth.error != null) ...[
                                      Text(widget.auth.error!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Color(0xFFF5A623), fontSize: 14)),
                                      const SizedBox(height: 14),
                                    ],
                                    GestureDetector(
                                      onTap: widget.auth.loading ? null : _submit,
                                      child: Container(
                                        width: double.infinity,
                                        height: 56,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF4F46E5)]),
                                          boxShadow: [
                                            BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.45), blurRadius: 22, offset: const Offset(0, 8)),
                                          ],
                                        ),
                                        child: const Text('LOGIN',
                                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 3.5)),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Contact administrateur pour créer un compte',
                            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14, letterSpacing: 0.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
