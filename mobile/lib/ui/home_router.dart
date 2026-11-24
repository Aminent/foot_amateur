import 'package:flutter/material.dart';

import '../state/auth_controller.dart';
import 'login_page.dart';
import 'main_navigation_wrapper.dart';
import 'referee_home_page.dart';

class HomeRouter extends StatelessWidget {
  final AuthController auth;
  const HomeRouter({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: auth,
      builder: (context, _) {
        if (auth.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!auth.isAuthed) {
          return LoginPage(auth: auth);
        }

        final role = auth.user!.role;
        if (role == 'coach' || role == 'joueur') {
          return MainNavigationWrapper(auth: auth);
        }
        if (role == 'arbitre') {
          return RefereeShell(auth: auth);
        }

        // If someone logs in as admin on mobile, show a simple message.
        return Scaffold(
          appBar: AppBar(title: const Text('Mobile')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Connecté en tant que: ${auth.user!.name} (${auth.user!.role})'),
                const SizedBox(height: 12),
                const Text(
                  'Le rôle admin est prévu pour le web. Utilisez l\'application web pour l\'administration.',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: auth.logout,
                  child: const Text('Se déconnecter'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

