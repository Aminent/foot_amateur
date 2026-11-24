// Composants visuels des accueils coach/joueur — reproduits d'après l'APK du 15/10.
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePalette {
  static const navy = [Color(0xFF07304F), Color(0xFF0A6496)];
  static const purple = [Color(0xFF7C3AC8), Color(0xFFB46CE6)];
  static const green = [Color(0xFF0F9E6A), Color(0xFF34D399)];
  static const orange = [Color(0xFFE07B0C), Color(0xFFF8C22C)];
  static const red = [Color(0xFFD62828), Color(0xFFEE6464)];
  static const sky = [Color(0xFF0778BC), Color(0xFF06BCDD)];
  static const cyan = [Color(0xFF12B4D6), Color(0xFF2CD3E6)];
  static const pinnedBar = Color(0xFF05365A);
  static const link = Color(0xFF0B5C8A);
  static const title = Color(0xFF0F172A);
  static const background = Color(0xFFF7F9FC);
}

LinearGradient diagonal(List<Color> c) =>
    LinearGradient(colors: c, begin: Alignment.topLeft, end: Alignment.bottomRight);

/// SliverAppBar repliable : en-tête dégradé + cloche/réglages, barre bleu nuit une fois repliée.
class HomeSliverHeader extends StatelessWidget {
  final String initials;
  final List<Color> avatarColors;
  final String name;
  final List<Widget> chips;
  final String club;
  final int notifCount;
  final VoidCallback onBell;
  final VoidCallback onSettings;

  const HomeSliverHeader({
    super.key,
    required this.initials,
    required this.avatarColors,
    required this.name,
    required this.chips,
    required this.club,
    required this.notifCount,
    required this.onBell,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 190,
      backgroundColor: HomePalette.pinnedBar,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      foregroundColor: Colors.white,
      actions: [
        Stack(children: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded, size: 30), onPressed: onBell),
          if (notifCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                child: Text(notifCount > 99 ? '99+' : '$notifCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
              ),
            ),
        ]),
        IconButton(icon: const Icon(Icons.settings_outlined, size: 30), onPressed: onSettings),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: BoxDecoration(gradient: diagonal(const [Color(0xFF062A45), Color(0xFF05679B)])),
          child: Stack(children: [
            Positioned(right: -70, top: -60, child: _circle(240, 0.07)),
            Positioned(left: 20, bottom: -60, child: _circle(120, 0.05)),
            Positioned(right: 40, bottom: -40, child: _circle(90, 0.05)),
            Padding(
              padding: EdgeInsets.fromLTRB(20, top + 56, 12, 16),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 66,
                  height: 66,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: diagonal(avatarColors),
                    boxShadow: [BoxShadow(color: avatarColors.last.withOpacity(0.55), blurRadius: 18)],
                  ),
                  child: Text(initials,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text('Bonjour,', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Wrap(spacing: 6, children: chips),
                    if (club.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.shield, color: Color(0xFF1FB6D9), size: 14),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(club,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Color(0xFF1FB6D9), fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ]),
                    ],
                  ]),
                ),
                SizedBox(width: 72, height: 60, child: Lottie.asset('assets/hello.json', fit: BoxFit.contain)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  static Widget _circle(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(opacity)),
      );
}

/// Pastille de l'en-tête (« Coach », « #1 », poste…).
class HeaderChip extends StatelessWidget {
  final String label;
  final Color? fill;
  final Color? border;
  final Color textColor;
  const HeaderChip(this.label, {super.key, this.fill, this.border, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(20),
          border: border == null ? null : Border.all(color: border!, width: 1.2),
        ),
        child: Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
      );
}

/// Carte statistique pleine (dégradé, texte blanc, cercle décoratif, Lottie optionnel).
class GradientStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final List<Color> colors;
  final String? lottie;
  final VoidCallback? onTap;
  const GradientStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.colors,
    this.lottie,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: diagonal(colors),
            boxShadow: [BoxShadow(color: colors.last.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6))],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(children: [
            Positioned(
              right: -28,
              top: -28,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.09)),
              ),
            ),
            if (lottie != null)
              Positioned(top: 4, right: 4, child: SizedBox(width: 64, height: 64, child: Lottie.asset(lottie!, fit: BoxFit.contain))),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.1)),
                  const SizedBox(height: 2),
                  Text(label, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, fontWeight: FontWeight.w500)),
                ]),
              ]),
            ),
          ]),
        ),
      );
}

/// Tuile « Accès rapide » : cercle dégradé + libellé court.
class QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;
  const QuickTile({super.key, required this.icon, required this.label, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.last.withOpacity(0.18), width: 1.4),
              boxShadow: [BoxShadow(color: colors.last.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: diagonal(colors)),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: HomePalette.title)),
            ]),
          ),
        ),
      );
}

/// Titre de section : carré bleu nuit avec icône + titre + « Voir tout ».
class HomeSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onSeeAll;
  const HomeSectionHeader(this.title, this.icon, {super.key, this.onSeeAll});

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(gradient: diagonal(HomePalette.navy), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.white, size: 15),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: HomePalette.title))),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text('Voir tout', style: TextStyle(color: HomePalette.link, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
      ]);
}

/// Carré dégradé à coins arrondis (numéros de maillot, icônes de match, « V/N/D »).
class GradientSquare extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final double size;
  const GradientSquare({super.key, required this.colors, required this.child, this.size = 40});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: diagonal(colors), borderRadius: BorderRadius.circular(12)),
        child: child,
      );
}

/// Couleurs par poste (effectif).
List<Color> positionColors(String? position) {
  switch ((position ?? '').toLowerCase()) {
    case 'gardien':
      return HomePalette.green;
    case 'defenseur':
      return [const Color(0xFF0A6FB0), const Color(0xFF2E9BD6)];
    case 'milieu':
      return HomePalette.purple;
    case 'attaquant':
      return HomePalette.orange;
    default:
      return HomePalette.navy;
  }
}

/// Dégradé des types de séance.
List<Color> trainingColors(String? type) {
  switch (type) {
    case 'match':
      return HomePalette.green;
    case 'physique':
      return HomePalette.orange;
    case 'tactique':
      return HomePalette.purple;
    case 'technique':
      return HomePalette.sky;
    default:
      return HomePalette.navy;
  }
}

String initialsOf(String? name) {
  final parts = (name ?? '').trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first[0] + parts.last[0]).toUpperCase();
}
