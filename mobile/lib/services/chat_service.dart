import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import './api_client.dart';
import '../models/user.dart';
import '../app_config.dart';

class TeamChatMessage {
  final String id;
  final String message;
  final String messageType;
  final User sender;
  final DateTime createdAt;
  final List<String> readBy;
  final String? attachmentUrl;

  TeamChatMessage({
    required this.id,
    required this.message,
    required this.messageType,
    required this.sender,
    required this.createdAt,
    required this.readBy,
    this.attachmentUrl,
  });

  factory TeamChatMessage.fromJson(Map<String, dynamic> json) {
    return TeamChatMessage(
      id: json['id'].toString(),
      message: json['message'] ?? '',
      messageType: json['messageType'] ?? 'text',
      sender: User.fromJson(json['sender']),
      createdAt: DateTime.parse(json['createdAt']),
      readBy: (json['readBy'] as List?)?.map((e) => e.toString()).toList() ?? [],
      attachmentUrl: json['attachmentUrl'],
    );
  }
}

class TeamChatInfo {
  final dynamic team;
  final List<dynamic> members;
  final int unreadCount;

  TeamChatInfo({
    required this.team,
    required this.members,
    required this.unreadCount,
  });

  factory TeamChatInfo.fromJson(Map<String, dynamic> json) {
    return TeamChatInfo(
      team: json['team'],
      members: List<dynamic>.from(json['members'] ?? []),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}

class TeamMessagesResult {
  final List<TeamChatMessage> messages;
  final int totalPages;
  final int currentPage;

  TeamMessagesResult({
    required this.messages,
    required this.totalPages,
    required this.currentPage,
  });

  bool get hasMore => currentPage < totalPages;
}

class ChatService {
  final ApiClient _apiClient;
  IO.Socket? _socket;

  ChatService(this._apiClient);

  /// Initialize socket connection with JWT authentication
  void initSocket() {
    final token = _apiClient.token;

    _socket = IO.io(
      AppConfig.socketUrl,
      IO.OptionBuilder()
        .setTransports(['websocket', 'polling'])
        .enableForceNew()
        .enableAutoConnect()
        .setReconnectionAttempts(5)
        .setReconnectionDelay(2000)
        // Pass JWT in handshake so the server can authenticate the socket
        .setAuth(token != null ? {'token': token} : {})
        .build(),
    );

    _socket?.connect();

    _socket?.onConnect((_) {
      debugPrint('[Socket] Connected');
    });

    _socket?.onDisconnect((_) {
      debugPrint('[Socket] Disconnected');
    });

    _socket?.on('connect_error', (data) {
      debugPrint('[Socket] Connection error: $data');
    });

    _socket?.onError((data) {
      debugPrint('[Socket] Error: $data');
    });
  }

  /// Join team room
  void joinTeam(String teamId) {
    if (_socket == null || _socket!.disconnected) initSocket();
    // Give it a moment to connect if it wasn't
    if (_socket!.connected) {
      _socket?.emit('join-team', teamId);
    } else {
      _socket?.onConnect((_) {
        _socket?.emit('join-team', teamId);
      });
    }
  }

  /// Listen for new messages
  void onNewMessage(Function(TeamChatMessage) callback) {
    _socket?.on('new_message', (data) {
      print('New message received: $data');
      if (data != null) {
        try {
          callback(TeamChatMessage.fromJson(data));
        } catch (e) {
          print('Error parsing message: $e');
        }
      }
    });
  }

  /// Dispose socket
  void dispose() {
    _socket?.disconnect();
    _socket = null;
  }

  /// Get team chat messages (newest first from server; reversed to ASC for display)
  Future<TeamMessagesResult> getTeamMessages({int page = 1, int limit = 50}) async {
    try {
      final response = await _apiClient.dio.get('/chat/messages', queryParameters: {
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        // Server returns DESC (newest first); reverse so index 0 = oldest for display
        final messages = (data['messages'] as List)
            .map((msg) => TeamChatMessage.fromJson(msg))
            .toList()
            .reversed
            .toList();
        final pagination = data['pagination'] as Map<String, dynamic>? ?? {};
        return TeamMessagesResult(
          messages: messages,
          totalPages: pagination['totalPages'] as int? ?? 1,
          currentPage: pagination['page'] as int? ?? page,
        );
      }
      throw Exception('Failed to load team messages');
    } catch (e) {
      throw Exception('Failed to load team messages: $e');
    }
  }

  /// Send a message to team chat
  Future<TeamChatMessage> sendTeamMessage({
    required String message,
    String messageType = 'text',
    String? attachmentUrl,
  }) async {
    try {
      final response = await _apiClient.dio.post('/chat/send', data: {
        'message': message,
        'messageType': messageType,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      });
      
      if (response.statusCode == 201) {
        final data = response.data;
        return TeamChatMessage.fromJson(data['chat']);
      }
      throw Exception('Failed to send message');
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Get team chat info (team members, unread count)
  Future<TeamChatInfo> getTeamChatInfo() async {
    try {
      final response = await _apiClient.dio.get('/chat/info');
      
      if (response.statusCode == 200) {
        final data = response.data;
        return TeamChatInfo.fromJson(data);
      }
      throw Exception('Failed to load team chat info');
    } catch (e) {
      throw Exception('Failed to load team chat info: $e');
    }
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(List<String> messageIds) async {
    try {
      await _apiClient.dio.post('/chat/mark-read', data: {
        'messageIds': messageIds.map((id) => int.parse(id)).toList(),
      });
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  /// Get unread message count
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.dio.get('/chat/unread-count');
      
      if (response.statusCode == 200) {
        final data = response.data;
        return data['unreadCount'] ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Format message time
  String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today - show time
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Hier';
    } else if (difference.inDays < 7) {
      // This week
      return '${difference.inDays}j';
    } else {
      // Older - show date
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  /// Get display name for user
  String getDisplayName(User user) {
    if (user.name.isNotEmpty) return user.name;
    return user.email.split('@')[0];
  }

  /// Check if message is from current user
  bool isFromCurrentUser(TeamChatMessage message, String currentUserId) {
    return message.sender.id.toString() == currentUserId;
  }

  /// Check if user has read the message
  bool isMessageRead(TeamChatMessage message, String currentUserId) {
    return message.readBy.contains(currentUserId);
  }
}
