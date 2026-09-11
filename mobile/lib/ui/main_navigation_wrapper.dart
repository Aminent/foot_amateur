import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  List<BottomNavigationBarItem> _buildNavItems() {
    final isCoach = widget.auth.user?.role == 'coach';
    
    if (isCoach) {
      return [
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 0 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 0 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.person,
              color: _selectedIndex == 0 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Mon profil',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 1 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 1 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.emoji_events,
              color: _selectedIndex == 1 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Mes Récompenses',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 2 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 2 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.fitness_center,
              color: _selectedIndex == 2 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Séance d\'entraînement',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 3 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 3 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.sports_soccer,
              color: _selectedIndex == 3 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Mes tournois',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 4 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 4 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.chat_bubble,
              color: _selectedIndex == 4 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Chat',
        ),
      ];
    } else {
      return [
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 0 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 0 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.person,
              color: _selectedIndex == 0 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Mon profil',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 1 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 1 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.emoji_events,
              color: _selectedIndex == 1 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Récompenses',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 2
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 2 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.sports_soccer,
              color: _selectedIndex == 2 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Mes matchs',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 3 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 3 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.fitness_center,
              color: _selectedIndex == 3 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Entraînements',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 4 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 4 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.chat_bubble,
              color: _selectedIndex == 4 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: _selectedIndex == 5 
                ? LinearGradient(
                    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  )
                : null,
              borderRadius: BorderRadius.circular(12),
              color: _selectedIndex == 5 ? null : Colors.transparent,
            ),
            child: Icon(
              Icons.bar_chart,
              color: _selectedIndex == 5 ? Colors.white : const Color(0xFF5F6368),
              size: 20,
            ),
          ),
          label: 'Statistiques',
        ),
      ];
    }
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFFFFF),

              const Color(0xFFF8F9FA),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildNavItems().asMap().entries.map((entry) {
                final index = entry.key;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == index 
                        ? const Color(0xFF00687B)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Chat icon gets a live unread badge; all others are plain
                        if (index == _chatTabIndex)
                          ValueListenableBuilder<int>(
                            valueListenable: _chatUnreadNotifier,
                            builder: (_, count, __) => Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  _getIconForIndex(index),
                                  color: _selectedIndex == index ? Colors.white : const Color(0xFF5F6368),
                                  size: 20,
                                ),
                                if (count > 0)
                                  Positioned(
                                    top: -5,
                                    right: -7,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                      child: Text(
                                        count > 99 ? '99+' : '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w800,
                                          height: 1.2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        else
                          Icon(
                            _getIconForIndex(index),
                            color: _selectedIndex == index ? Colors.white : const Color(0xFF5F6368),
                            size: 20,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          _getLabelForIndex(index),
                          style: GoogleFonts.poppins(
                            color: _selectedIndex == index ? Colors.white : const Color(0xFF5F6368),
                            fontSize: 10,
                            fontWeight: _selectedIndex == index ? FontWeight.w600 : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    final isCoach = widget.auth.user?.role == 'coach';
    
    if (isCoach) {
      switch (index) {
        case 0: return Icons.person;
        case 1: return Icons.group;
        case 2: return Icons.fitness_center;
        case 3: return Icons.sports_soccer;
        case 4: return Icons.chat_bubble;
        default: return Icons.person;
      }
    } else {
      switch (index) {
        case 0:
          return Icons.person;
        case 1:
          return Icons.emoji_events;
        case 2:
          return Icons.sports_soccer;
        case 3:
          return Icons.fitness_center;
        case 4:
          return Icons.chat_bubble;
        case 5:
          return Icons.bar_chart;
        default:
          return Icons.person;
      }
    }
  }

  String _getLabelForIndex(int index) {
    final isCoach = widget.auth.user?.role == 'coach';
    
    if (isCoach) {
      switch (index) {
        case 0: return 'Profil';
        case 1: return 'Équipe';
        case 2: return 'Entraînement';
        case 3: return 'Tournois';
        case 4: return 'Chat';
        default: return 'Profil';
      }
    } else {
      switch (index) {
        case 0:
          return 'Profil';
        case 1:
          return 'Récompenses';
        case 2:
          return 'Matchs';
        case 3:
          return 'Entraînements';
        case 4:
          return 'Chat';
        case 5:
          return 'Stats';
        default:
          return 'Profil';
      }
    }
  }
}
