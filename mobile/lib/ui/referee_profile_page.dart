// Espace Arbitre — reconstruit d'après l'APK du 15/10.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_client.dart';
import '../services/notification_service.dart';
import '../services/referee_service.dart';
import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import 'referee_home_page.dart' show refereeAccent;

class RefereeProfilePage extends StatefulWidget {
  final AuthController auth;
  const RefereeProfilePage({super.key, required this.auth});

  @override
  State<RefereeProfilePage> createState() => _RefereeProfilePageState();
}

class _RefereeProfilePageState extends State<RefereeProfilePage> {
  late final ApiClient _api = ApiClient(token: widget.auth.token);
  RefereeStats? _stats;

  @override
  void initState() {
    super.initState();
    RefereeService(_api).getMyStats().then((s) {
      if (mounted) setState(() => _stats = s);
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.auth.user;
    final s = _stats;
    Widget row(IconData icon, String label, String value) => ListTile(
          leading: Icon(icon, color: refereeAccent),
          title: Text(label),
          trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        );
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Profil', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: ListView(children: [
        const SizedBox(height: 24),
        const Center(child: CircleAvatar(radius: 40, backgroundColor: refereeAccent, child: Icon(Icons.sports, color: Color(0xFFFBBF24), size: 38))),
        const SizedBox(height: 12),
        Center(child: Text(user?.name ?? '', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600))),
        Center(child: Text(user?.email ?? '', style: const TextStyle(color: AppColors.textSecondary))),
        const SizedBox(height: 6),
        const Center(child: Chip(label: Text('Arbitre'))),
        const SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.borderGrey)),
          child: Column(children: [
            row(Icons.assignment_outlined, 'Total missions', '${s?.totalMissions ?? '–'}'),
            row(Icons.sports_soccer, 'Matchs arbitrés', '${s?.matchesRefereed ?? '–'}'),
            row(Icons.thumb_up_alt_outlined, 'Taux d\'acceptation', s == null ? '–' : '${s.acceptanceRate}%'),
            row(Icons.hourglass_top, 'En attente', '${s?.pending ?? '–'}'),
            row(Icons.gavel, 'Contestations officielles', '${s?.officialDisputes ?? '–'}'),
          ]),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: () async {
              await NotificationService.instance.unregisterToken(_api, userRole: 'arbitre');
              await widget.auth.logout();
            },
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.errorRed, minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
          ),
        ),
        const SizedBox(height: 32),
      ]),
    );
  }
}
