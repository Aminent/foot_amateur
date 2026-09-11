import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
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
  }

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

  @override
  Widget build(BuildContext context) {
    // Show loading screen during login
    if (widget.auth.loading) {
      return LoadingScreen(
        message: 'Connexion en cours...',
        showBackground: true,
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/foot-bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: AnimatedBuilder(
            animation: widget.auth,
            builder: (context, _) {
              return Stack(
                children: [
                  // Main content
                  Center(
                    child: SingleChildScrollView(
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Footballer animation with gradient
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Lottie.asset(
                                    'assets/footballer.json',
                                    height: 120,
                                    width: 120,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Title with gradient effect
                                Text(
                                  'Foot Amateur',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.5),
                                            offset: const Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Connectez-vous à votre compte',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.3),
                                            offset: const Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                ),
                                const SizedBox(height: 32),

                                // Login card
                                Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  color: Colors.white.withOpacity(0.95),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          // Email field
                                          TextFormField(
                                            controller: _email,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            enabled: !widget.auth.loading,
                                            decoration: InputDecoration(
                                              labelText: 'Adresse email',
                                              prefixIcon: const Icon(
                                                Icons.email_outlined,
                                                color: AppColors.primaryBlue,
                                              ),
                                              hintText:
                                                  'exemple@email.com',
                                            ),
                                            validator: (v) {
                                              if (v == null ||
                                                  v.trim().isEmpty) {
                                                return 'Email requis';
                                              }
                                              if (!v.contains('@')) {
                                                return 'Email invalide';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 20),

                                          // Password field
                                          TextFormField(
                                            controller: _password,
                                            obscureText: true,
                                            enabled: !widget.auth.loading,
                                            decoration: InputDecoration(
                                              labelText: 'Mot de passe',
                                              prefixIcon: const Icon(
                                                Icons.lock_outline,
                                                color: AppColors.primaryBlue,
                                              ),
                                              hintText: 'Votre mot de passe',
                                            ),
                                            validator: (v) {
                                              if (v == null || v.isEmpty) {
                                                return 'Mot de passe requis';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 28),

                                          // Error message
                                          if (widget.auth.error != null) ...[
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: AppColors.errorRed
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: AppColors.errorRed,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.error_outline,
                                                    color: AppColors.errorRed,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      widget.auth.error!,
                                                      style:
                                                          TextStyle(
                                                            color: AppColors
                                                                .errorRed,
                                                            fontSize: 14,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                          ],

                                          // Login button
                                          SizedBox(
                                            width: double.infinity,
                                            height: 52,
                                            child: ElevatedButton(
                                              onPressed:
                                                  widget.auth.loading
                                                      ? null
                                                      : _submit,
                                              child: widget.auth.loading
                                                  ? const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2.5,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                              Colors.white,
                                                            ),
                                                          ),
                                                    )
                                                  : const Text(
                                                      'Se connecter',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Footer text
                                Text(
                                  'Contact administrateur pour créer un compte',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.3),
                                            offset: const Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

