// Espace Arbitre — reconstruit d'après l'APK du 15/10.
// Deux feuilles à scanner : présence (avant match) et feuille complétée (après match).
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../app_config.dart';
import '../services/api_client.dart';
import '../services/referee_service.dart';
import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import 'referee_home_page.dart' show formatMatchDate, refereeAccent;

class RefereeMatchSheetPage extends StatefulWidget {
  final AuthController auth;
  final RefereeMission mission;
  const RefereeMatchSheetPage({super.key, required this.auth, required this.mission});

  @override
  State<RefereeMatchSheetPage> createState() => _RefereeMatchSheetPageState();
}

class _RefereeMatchSheetPageState extends State<RefereeMatchSheetPage> {
  late final RefereeService _refereeService = RefereeService(ApiClient(token: widget.auth.token));
  final _picker = ImagePicker();
  late String? _presenceUrl = widget.mission.presenceSheetUrl;
  late String? _matchUrl = widget.mission.matchSheetUrl;
  String? _uploading; // 'presence' | 'match'

  Future<void> _scan(String type) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(leading: const Icon(Icons.photo_camera_outlined), title: const Text('Prendre une photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera)),
          ListTile(leading: const Icon(Icons.photo_library_outlined), title: const Text('Choisir dans la galerie'),
              onTap: () => Navigator.pop(context, ImageSource.gallery)),
        ]),
      ),
    );
    if (source == null) return;
    final file = await _picker.pickImage(source: source, imageQuality: 80, maxWidth: 2400);
    if (file == null) return;

    setState(() => _uploading = type);
    try {
      final url = await _refereeService.uploadSheet(widget.mission.id,
          bytes: await file.readAsBytes(), filename: file.name, type: type);
      if (!mounted) return;
      setState(() => type == 'match' ? _matchUrl = url : _presenceUrl = url);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feuille envoyée')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => _uploading = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mission;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Feuille de match', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: refereeAccent, borderRadius: BorderRadius.circular(18)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.roleLabel, style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('${m.homeTeam}  vs  ${m.awayTeam}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            if (m.isCompleted)
              Text('Score final : ${m.homeScore} - ${m.awayScore}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Text('${formatMatchDate(m.date)} · ${m.location}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 20),
        _SheetCard(
          title: 'Feuille de présence',
          hint: 'Scannez la feuille avec les joueurs sélectionnés',
          url: _presenceUrl,
          uploading: _uploading == 'presence',
          onScan: _uploading == null ? () => _scan('presence') : null,
        ),
        const SizedBox(height: 12),
        _SheetCard(
          title: 'Feuille de match complétée',
          hint: 'Scannez la feuille complétée avec les faits du match',
          url: _matchUrl,
          uploading: _uploading == 'match',
          onScan: _uploading == null ? () => _scan('match') : null,
        ),
      ]),
    );
  }
}

class _SheetCard extends StatelessWidget {
  final String title;
  final String hint;
  final String? url;
  final bool uploading;
  final VoidCallback? onScan;
  const _SheetCard({required this.title, required this.hint, required this.url, required this.uploading, this.onScan});

  @override
  Widget build(BuildContext context) {
    final done = url != null;
    final base = AppConfig.apiBaseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.borderGrey)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(done ? Icons.check_circle : Icons.description_outlined, color: done ? AppColors.successGreen : AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
          ]),
          const SizedBox(height: 6),
          Text(hint, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          if (done) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network('$base$url',
                  height: 180, width: double.infinity, fit: BoxFit.cover,
                  headers: const {'ngrok-skip-browser-warning': 'true'},
                  errorBuilder: (_, __, ___) => const SizedBox(height: 60, child: Center(child: Text('Aperçu indisponible')))),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onScan,
              style: FilledButton.styleFrom(backgroundColor: refereeAccent),
              icon: uploading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.document_scanner_outlined),
              label: Text(done ? 'Scanner à nouveau' : 'Scanner la feuille'),
            ),
          ),
        ]),
      ),
    );
  }
}
