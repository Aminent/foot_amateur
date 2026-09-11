import 'package:flutter/material.dart';
import '../services/player_service.dart';
import '../services/api_client.dart';
import '../state/auth_controller.dart';

class PlayerEditProfilePage extends StatefulWidget {
  final AuthController auth;
  final Map<String, dynamic> playerData;

  const PlayerEditProfilePage({
    super.key,
    required this.auth,
    required this.playerData,
  });

  @override
  State<PlayerEditProfilePage> createState() => _PlayerEditProfilePageState();
}

class _PlayerEditProfilePageState extends State<PlayerEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final PlayerService _service;
  bool _saving = false;

  late final TextEditingController _phoneCtrl;
  late final TextEditingController _nationalityCtrl;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _jerseyCtrl;
  late final TextEditingController _dobCtrl;

  String? _position;
  String? _preferredFoot;

  static const _positions = ['Gardien', 'Défenseur', 'Milieu', 'Attaquant'];
  static const _feet = ['Droit', 'Gauche', 'Ambidextre'];
  static const _teal = Color(0xFF55C1CF);

  @override
  void initState() {
    super.initState();
    _service = PlayerService(ApiClient(token: widget.auth.token));
    final p = widget.playerData;
    _phoneCtrl       = TextEditingController(text: p['phone']?.toString() ?? '');
    _nationalityCtrl = TextEditingController(text: p['nationality']?.toString() ?? '');
    _heightCtrl      = TextEditingController(text: p['height']?.toString() ?? '');
    _weightCtrl      = TextEditingController(text: p['weight']?.toString() ?? '');
    _jerseyCtrl      = TextEditingController(text: p['jerseyNumber']?.toString() ?? '');
    _dobCtrl         = TextEditingController(text: _fmtDob(p['dateOfBirth']?.toString()));
    _position        = _normalizePos(p['position']?.toString());
    _preferredFoot   = _normalizeFoot(p['preferredFoot']?.toString());
  }

  @override
  void dispose() {
    _phoneCtrl.dispose(); _nationalityCtrl.dispose(); _heightCtrl.dispose();
    _weightCtrl.dispose(); _jerseyCtrl.dispose(); _dobCtrl.dispose();
    super.dispose();
  }

  String _fmtDob(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final d = DateTime.parse(raw);
      return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
    } catch (_) { return raw; }
  }

  String? _normalizePos(String? raw) {
    if (raw == null) return null;
    final l = raw.toLowerCase();
    if (l.contains('gard')) return 'Gardien';
    if (l.contains('déf') || l.contains('def')) return 'Défenseur';
    if (l.contains('mil')) return 'Milieu';
    if (l.contains('att') || l.contains('avant')) return 'Attaquant';
    return null;
  }

  String? _normalizeFoot(String? raw) {
    if (raw == null) return null;
    final l = raw.toLowerCase();
    if (l == 'droit') return 'Droit';
    if (l == 'gauche') return 'Gauche';
    if (l.contains('ambi')) return 'Ambidextre';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    // Parse dob from DD/MM/YYYY
    String? dobIso;
    final dobTxt = _dobCtrl.text.trim();
    if (dobTxt.isNotEmpty) {
      try {
        final parts = dobTxt.split('/');
        if (parts.length == 3) {
          dobIso = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0])).toIso8601String();
        }
      } catch (_) {}
    }

    final data = <String, dynamic>{
      if (_position != null) 'position': _position!.toLowerCase(),
      if (_preferredFoot != null) 'preferredFoot': _preferredFoot!.toLowerCase(),
      if (_jerseyCtrl.text.trim().isNotEmpty) 'jerseyNumber': int.tryParse(_jerseyCtrl.text.trim()),
      if (_phoneCtrl.text.trim().isNotEmpty) 'phone': _phoneCtrl.text.trim(),
      if (_nationalityCtrl.text.trim().isNotEmpty) 'nationality': _nationalityCtrl.text.trim(),
      if (_heightCtrl.text.trim().isNotEmpty) 'height': double.tryParse(_heightCtrl.text.trim()),
      if (_weightCtrl.text.trim().isNotEmpty) 'weight': double.tryParse(_weightCtrl.text.trim()),
      if (dobIso != null) 'dateOfBirth': dobIso,
    };

    final ok = await _service.updateMyProfile(data);
    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour ✓'), backgroundColor: Color(0xFF16A34A)),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la mise à jour'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_saving)
            const Center(child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            ))
          else
            TextButton(
              onPressed: _save,
              child: const Text('Enregistrer', style: TextStyle(color: _teal, fontWeight: FontWeight.w700, fontSize: 15)),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // ── Avatar placeholder ────────────────────────────────────────────
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(
                      color: _teal.withAlpha(40),
                      shape: BoxShape.circle,
                      border: Border.all(color: _teal, width: 2),
                    ),
                    child: const Icon(Icons.person, color: _teal, size: 48),
                  ),
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: _teal, shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                widget.auth.user?.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 28),

            // ── Section Terrain ───────────────────────────────────────────────
            _sectionHeader('Informations terrain', Icons.sports_soccer),
            const SizedBox(height: 12),
            _card(Column(children: [
              _labeledField('Poste', child: _chipSelector(_positions, _position, (v) => setState(() => _position = v))),
              const Divider(height: 24),
              _labeledField('Pied préféré', child: _chipSelector(_feet, _preferredFoot, (v) => setState(() => _preferredFoot = v))),
              const Divider(height: 24),
              _field(controller: _jerseyCtrl, label: 'Numéro de maillot', icon: Icons.tag, keyboard: TextInputType.number),
            ])),

            const SizedBox(height: 24),

            // ── Section Personnelle ───────────────────────────────────────────
            _sectionHeader('Informations personnelles', Icons.person_outline),
            const SizedBox(height: 12),
            _card(Column(children: [
              _field(controller: _phoneCtrl, label: 'Téléphone', icon: Icons.phone_outlined, keyboard: TextInputType.phone),
              const Divider(height: 24),
              _field(controller: _nationalityCtrl, label: 'Nationalité', icon: Icons.flag_outlined),
              const Divider(height: 24),
              _field(
                controller: _dobCtrl, label: 'Date de naissance (JJ/MM/AAAA)',
                icon: Icons.cake_outlined, keyboard: TextInputType.datetime,
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final parts = v.split('/');
                  if (parts.length != 3) return 'Format: JJ/MM/AAAA';
                  return null;
                },
              ),
            ])),

            const SizedBox(height: 24),

            // ── Section Physique ──────────────────────────────────────────────
            _sectionHeader('Données physiques', Icons.straighten),
            const SizedBox(height: 12),
            _card(Row(children: [
              Expanded(child: _field(controller: _heightCtrl, label: 'Taille (cm)', icon: Icons.height, keyboard: TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(child: _field(controller: _weightCtrl, label: 'Poids (kg)', icon: Icons.monitor_weight_outlined, keyboard: TextInputType.number)),
            ])),

            const SizedBox(height: 32),

            // ── Save button ───────────────────────────────────────────────────
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _teal.withAlpha(100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _saving
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Enregistrer les modifications', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon) => Row(children: [
    Icon(icon, size: 17, color: const Color(0xFF64748B)),
    const SizedBox(width: 8),
    Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 1.1)),
  ]);

  Widget _card(Widget child) => Container(
    width: double.infinity, padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2))],
    ),
    child: child,
  );

  Widget _labeledField(String label, {required Widget child}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
      const SizedBox(height: 10),
      child,
    ],
  );

  Widget _chipSelector(List<String> options, String? selected, ValueChanged<String> onTap) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: options.map((o) {
        final sel = selected == o;
        return GestureDetector(
          onTap: () => onTap(o),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: sel ? _teal : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sel ? _teal : const Color(0xFFE2E8F0), width: sel ? 1.5 : 1),
            ),
            child: Text(o, style: TextStyle(
              color: sel ? Colors.white : const Color(0xFF475569),
              fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            )),
          ),
        );
      }).toList(),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        filled: true, fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _teal, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
