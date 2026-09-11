import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import '../services/chat_service.dart';
import '../services/api_client.dart';
import '../services/notification_service.dart';
import '../widgets/custom_widgets.dart';

class ChatListPage extends StatefulWidget {
  final AuthController auth;
  /// Notifier owned by MainNavigationWrapper — this page writes the live
  /// unread count so the nav bar badge updates without rebuilding the whole tree.
  final ValueNotifier<int> unreadNotifier;
  const ChatListPage({super.key, required this.auth, required this.unreadNotifier});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with TickerProviderStateMixin {
  late ChatService _chatService;
  List<TeamChatMessage> _messages = [];
  bool _isLoading = true;
  String? _error;
  int _unreadCount = 0;
  TeamChatInfo? _teamInfo;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;
  late AnimationController _fadeController;

  // Pagination
  int _currentPage = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // isChatOpen is managed by MainNavigationWrapper based on selected tab
    _chatService = ChatService(ApiClient(token: widget.auth.token));
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _chatService.dispose();
    _fadeController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Initialize socket for real-time updates
      _chatService.initSocket();

      final teamInfo = await _chatService.getTeamChatInfo();
      final result = await _chatService.getTeamMessages(page: 1);
      final unreadCount = await _chatService.getUnreadCount();

      if (mounted) {
        setState(() {
          _teamInfo = teamInfo;
          _messages = result.messages;
          _currentPage = 1;
          _hasMore = result.hasMore;
          _unreadCount = unreadCount;
          _isLoading = false;
          // Sync badge — if user is already on this tab the wrapper resets it to 0,
          // but set it here too so it's accurate before they open chat.
          widget.unreadNotifier.value = unreadCount;
        });

        // Join the team socket room for real-time messages
        final teamData = teamInfo.team is Map ? teamInfo.team as Map : {};
        if (teamData.containsKey('id')) {
          final teamId = teamData['id'].toString();
          _chatService.joinTeam(teamId);

          // Listen for incoming messages in real time
          _chatService.onNewMessage((message) {
            if (mounted) {
              if (!_messages.any((m) => m.id == message.id)) {
                setState(() => _messages.add(message));
                if (NotificationService.isChatOpen) {
                  // User is viewing the chat — mark read immediately, clear badge
                  setState(() => _unreadCount = 0);
                  widget.unreadNotifier.value = 0;
                  _scrollToBottom();
                  _chatService.markMessagesAsRead([message.id]);
                } else {
                  // User is on another tab — increment badge AND show a banner
                  setState(() => _unreadCount++);
                  widget.unreadNotifier.value = _unreadCount;

                  final senderName = message.sender.name ?? 'Nouveau message';
                  final preview = message.message.length > 80
                      ? '${message.message.substring(0, 80)}…'
                      : message.message;
                  final teamId = _teamInfo?.team is Map
                      ? (_teamInfo!.team as Map)['id']?.toString()
                      : null;

                  NotificationService.instance.showLocalChatNotification(
                    messageId: message.id,
                    senderName: senderName,
                    messagePreview: preview,
                    teamId: teamId,
                  );
                }
              }
            }
          });
        }

        // Mark existing messages as read
        final currentUserId = widget.auth.user?.id.toString() ?? '';
        final unreadIds = result.messages
            .where((msg) => !_chatService.isMessageRead(msg, currentUserId))
            .map((msg) => msg.id)
            .toList();
        if (unreadIds.isNotEmpty) {
          _chatService.markMessagesAsRead(unreadIds).then((_) {
            if (mounted) {
              setState(() => _unreadCount = 0);
              widget.unreadNotifier.value = 0;
            }
          });
        }

        // Scroll to latest message
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        // Start entry animation
        _fadeController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chat d\'Équipe'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.98),
              AppColors.background.withOpacity(0.95),
            ],
          ),
        ),
        child: Column(
          children: [
            // Team info header (remplace l'app bar custom)
            if (_teamInfo != null) _buildTeamInfoHeader(),
            Expanded(
              child: _isLoading
                  ? _buildModernLoadingState()
                  : _error != null
                      ? AppErrorWidget(
                          message: _error,
                          onRetry: _loadData,
                        )
                      : _teamInfo == null
                          ? _buildModernNoTeamState()
                          : _buildModernTeamChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfoHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: AppColors.borderGrey,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFBBEDE6),
                  const Color(0xFFBBEDE6).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.groups,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _teamInfo?.team['name'] ?? 'Équipe',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_teamInfo?.members.length ?? 0} membres',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.errorRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernNoTeamState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.group_off_rounded,
              size: 60,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune équipe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vous devez être assigné à une équipe\npour accéder au chat',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTeamChat() {
    return Column(
      children: [
        // Messages list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            color: const Color(0xFF00687B),
            child: _messages.isEmpty
                ? _buildModernNoMessagesState()
                : _buildModernMessagesList(),
          ),
        ),

        // Modern message input
        _buildModernMessageInput(),
      ],
    );
  }

  Widget _buildModernNoMessagesState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBBEDE6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: const Color(0xFFBBEDE6).withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 60,
                    color: Color(0xFFBBEDE6),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Aucun message',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Soyez le premier à envoyer un message !',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernMessagesList() {
    // +1 for the "load older" header slot at index 0
    final itemCount = _messages.length + 1;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // First slot: load-older button or top spacer
        if (index == 0) {
          if (_hasMore || _isLoadingMore) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: _isLoadingMore
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton.icon(
                        onPressed: _loadOlderMessages,
                        icon: const Icon(Icons.history_rounded, size: 18),
                        label: const Text('Messages précédents'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF00687B),
                        ),
                      ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final message = _messages[index - 1];
        final isFromCurrentUser = _chatService.isFromCurrentUser(
            message, widget.auth.user?.id.toString() ?? '');

        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: _buildModernMessageBubble(message, isFromCurrentUser),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernMessageBubble(TeamChatMessage message, bool isFromCurrentUser) {
    final isRead = _chatService.isMessageRead(message, widget.auth.user?.id.toString() ?? '');
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isFromCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromCurrentUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFBBEDE6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFBBEDE6).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  message.sender?.name?.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xFFBBEDE6),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isFromCurrentUser 
                    ? const Color(0xFF00687B)
                    : Colors.white,
                border: Border.all(
                  color: isFromCurrentUser 
                      ? const Color(0xFF00687B).withOpacity(0.3)
                      : AppColors.borderGrey,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isFromCurrentUser 
                        ? const Color(0xFF00687B).withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isFromCurrentUser)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          message.sender?.name ?? 'Utilisateur',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: const Color(0xFFBBEDE6),
                          ),
                        ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    Text(
                      message.message ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: isFromCurrentUser ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatMessageTime(message.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: isFromCurrentUser 
                                ? Colors.white.withOpacity(0.7)
                                : AppColors.textSecondary,
                          ),
                        ),
                        if (isFromCurrentUser) ...[
                          const SizedBox(width: 4),
                          Icon(
                            isRead ? Icons.done_all : Icons.done,
                            size: 12,
                            color: isRead 
                                ? Colors.white.withOpacity(0.9)
                                : Colors.white.withOpacity(0.6),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFBBEDE6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFBBEDE6).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  widget.auth.user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xFFBBEDE6),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.borderGrey,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.borderGrey,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Tapez votre message...',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFBBEDE6),
                  const Color(0xFFBBEDE6).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFBBEDE6).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: _isSending ? null : _sendMessage,
                child: Center(
                  child: _isSending
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFBBEDE6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color(0xFFBBEDE6).withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFBBEDE6)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Chargement du chat...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      if (difference.inHours == 1) {
        // Si c'est dans l'heure, afficher l'heure exacte
        return 'Aujourd\'hui à ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else {
        return 'Il y a ${difference.inHours} h';
      }
    } else if (difference.inDays < 7) {
      if (difference.inDays == 1) {
        // Hier, afficher l'heure exacte
        return 'Hier à ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else {
        return 'Il y a ${difference.inDays} j';
      }
    } else {
      // Pour les messages plus anciens, afficher la date complète avec l'heure
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} à ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _isSending = true;
    });

    try {
      final message = await _chatService.sendTeamMessage(
        message: messageText,
      );

      setState(() {
        if (!_messages.any((m) => m.id == message.id)) {
          _messages.add(message);
        }
        _isSending = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isSending = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error sending message',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _loadOlderMessages() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    try {
      final nextPage = _currentPage + 1;
      final result = await _chatService.getTeamMessages(page: nextPage);

      if (mounted) {
        // Remember scroll position so it doesn't jump after prepend
        final prevExtent = _scrollController.hasClients
            ? _scrollController.position.maxScrollExtent
            : 0.0;

        setState(() {
          _messages = [...result.messages, ..._messages];
          _currentPage = nextPage;
          _hasMore = result.hasMore;
          _isLoadingMore = false;
        });

        // Maintain scroll position after prepending older messages
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            final newExtent = _scrollController.position.maxScrollExtent;
            _scrollController.jumpTo(newExtent - prevExtent);
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
