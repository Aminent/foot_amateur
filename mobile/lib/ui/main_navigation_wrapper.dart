import 'package:flutter/material.dart';

import '../state/auth_controller.dart';
import '../services/notification_service.dart';
import 'player_home_page.dart';
import 'player_rewards_page.dart';
import 'player_matches_page.dart';
import 'player_training_page.dart';
import 'player_stats_page.dart';
import 'chat_list_page.dart';
import 'coach_home_page.dart';
import 'coach_team_page.dart';
import 'coach_training_page.dart';
import 'coach_tournaments_page.dart';

class MainNavigationWrapper extends StatefulWidget {
  final AuthController auth;
  const MainNavigationWrapper({super.key, required this.auth});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
  
  // Static method to access navigation state from child widgets
  static _MainNavigationWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainNavigationWrapperState>();
  }
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;
  late PageController _pageController;

  /// Shared unread-count notifier — ChatListPage writes to it,
  /// the nav bar icon reads from it via ValueListenableBuilder.
  final ValueNotifier<int> _chatUnreadNotifier = ValueNotifier(0);

  // Method to navigate to specific tab
  void navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    NotificationService.isChatOpen = (index == _chatTabIndex);
    if (index == _chatTabIndex) _chatUnreadNotifier.value = 0;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Chat tab index is 4 for both coach and player layouts
  static const int _chatTabIndex = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Start with chat closed (tab 0 is selected by default)
    NotificationService.isChatOpen = false;

    // When any notification is tapped, navigate to the relevant tab
    NotificationService.onNotificationTap = (data) {
      final type = data['type'] ?? '';
      final isCoach = widget.auth.user?.role == 'coach';
      switch (type) {
        case 'chat_message':
          navigateToTab(_chatTabIndex);
          break;
        case 'lineup_published':
          // Players: no dedicated lineup tab — go to home where lineup is visible
          navigateToTab(0);
          break;
        case 'training_scheduled':
        case 'training_updated':
          // Coach: tab 2 | Player: tab 3
          navigateToTab(isCoach ? 2 : 3);
          break;
        case 'match_reminder':
        case 'score_update':
        case 'match_result':
          // Coach: tab 3 (tournaments) | Player: tab 2 (matches)
          navigateToTab(isCoach ? 3 : 2);
          break;
        default:
          break;
      }
    };
  }

  @override
  void dispose() {
    NotificationService.onNotificationTap = null;
    _pageController.dispose();
    _chatUnreadNotifier.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    NotificationService.isChatOpen = (index == _chatTabIndex);
    if (index == _chatTabIndex) _chatUnreadNotifier.value = 0;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<Widget> _buildPages() {
    final isCoach = widget.auth.user?.role == 'coach';
    
    if (isCoach) {
      return [
        CoachHomePage(auth: widget.auth),
        CoachTeamPage(auth: widget.auth),
        CoachTrainingPage(auth: widget.auth, onBackToProfile: () => _navigateToProfile()),
        CoachTournamentsPage(auth: widget.auth, onBackToProfile: () => _navigateToProfile()),
        ChatListPage(auth: widget.auth, unreadNotifier: _chatUnreadNotifier),
      ];
    } else {
      return [
        PlayerHomePage(auth: widget.auth),
        PlayerRewardsPage(auth: widget.auth),
        PlayerMatchesPage(auth: widget.auth),
        PlayerTrainingPage(auth: widget.auth),
        ChatListPage(auth: widget.auth, unreadNotifier: _chatUnreadNotifier),
        PlayerStatsPage(auth: widget.auth, onBackToProfile: () => _navigateToProfile()),
      ];
    }
  }

  void _navigateToProfile() {
    setState(() {
      _selectedIndex = 0;
    });
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
          NotificationService.isChatOpen = (index == _chatTabIndex);
          if (index == _chatTabIndex) _chatUnreadNotifier.value = 0;
        },
        children: _buildPages(),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }


  // ── Barre de navigation (design de l'APK du 15/10) ─────────────────────────
  // Fond blanc, trait dégradé au-dessus de l'onglet actif, icône contour
  // quand inactif / pleine quand actif, libellés courts.
  static const _navActive = Color(0xFF0B2A44);
  static const _navInactive = Color(0xFF8A9AAE);

  Widget _buildBottomBar() {
    final count = widget.auth.user?.role == 'coach' ? 5 : 6;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: List.generate(count, (index) {
              final selected = _selectedIndex == index;
              final color = selected ? _navActive : _navInactive;
              Widget icon = Icon(_getIconForIndex(index, selected), color: color, size: 25);
              if (index == _chatTabIndex) {
                icon = ValueListenableBuilder<int>(
                  valueListenable: _chatUnreadNotifier,
                  child: icon,
                  builder: (_, unread, child) => Stack(clipBehavior: Clip.none, children: [
                    child!,
                    if (unread > 0)
                      Positioned(
                        top: -4,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                          child: Text(unread > 99 ? '99+' : '$unread',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800, height: 1.2)),
                        ),
                      ),
                  ]),
                );
              }
              return Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(index),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 4,
                        width: selected ? 48 : 0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(colors: [Color(0xFF0B3D5C), Color(0xFF17B3D6)]),
                        ),
                      ),
                      const Spacer(),
                      icon,
                      const SizedBox(height: 4),
                      Text(
                        _getLabelForIndex(index),
                        maxLines: 1,
                        style: TextStyle(
                          color: color,
                          fontSize: 11.5,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index, bool selected) {
    final isCoach = widget.auth.user?.role == 'coach';
    final icons = isCoach
        ? const [
            [Icons.person_outline, Icons.person],
            [Icons.people_outline, Icons.people],
            [Icons.fitness_center, Icons.fitness_center],
            [Icons.emoji_events_outlined, Icons.emoji_events],
            [Icons.chat_bubble_outline, Icons.chat_bubble],
          ]
        : const [
            [Icons.person_outline, Icons.person],
            [Icons.emoji_events_outlined, Icons.emoji_events],
            [Icons.sports_soccer, Icons.sports_soccer],
            [Icons.fitness_center, Icons.fitness_center],
            [Icons.chat_bubble_outline, Icons.chat_bubble],
            [Icons.bar_chart, Icons.bar_chart],
          ];
    return icons[index][selected ? 1 : 0];
  }

  String _getLabelForIndex(int index) {
    final isCoach = widget.auth.user?.role == 'coach';
    const coach = ['Profil', 'Équipe', 'Entraîn.', 'Tournois', 'Chat'];
    const player = ['Profil', 'Récomp.', 'Matchs', 'Entraîn.', 'Chat', 'Stats'];
    return (isCoach ? coach : player)[index];
  }
}
