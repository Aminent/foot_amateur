import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api_client.dart';
import 'notification_prefs_service.dart';

/// Top-level handler required by firebase_messaging for background messages.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background message received — flutter_local_notifications shows the notification
  // automatically via the FCM system tray when the app is killed.
  debugPrint('[FCM BG] ${message.notification?.title}: ${message.notification?.body}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  /// Set to true while ChatListPage is visible so foreground FCM chat
  /// notifications are not shown as banners (the message already appears
  /// inline via Socket.IO).
  static bool isChatOpen = false;

  /// Register a handler that gets called when the user taps a notification.
  /// The argument is the data payload map (e.g. {'type': 'chat_message', ...}).
  /// Set this in MainNavigationWrapper so it can switch to the right tab.
  static void Function(Map<String, String> data)? onNotificationTap;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  /// IDs of chat notifications already shown via Socket.IO — used to suppress
  /// the duplicate FCM `onMessage` delivery that arrives a moment later.
  final Set<int> _shownSocketNotifIds = {};

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'foot_amateur_default',
    'Foot Amateur',
    description: 'Notifications entraînements, matchs et résultats',
    importance: Importance.high,
    playSound: true,
  );

  /// Call once from main() after Firebase.initializeApp()
  Future<void> init(ApiClient apiClient, {required String userRole}) async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Android notification channel
    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Initialize flutter_local_notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotif.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request permission (Android 13+ / iOS)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[FCM] Permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    // Get token and register with backend
    final token = await _fcm.getToken();
    if (token != null) {
      debugPrint('[FCM] Token: ${token.substring(0, 20)}...');
      await _registerToken(apiClient, token, userRole);
    }

    // Refresh token handler
    _fcm.onTokenRefresh.listen((newToken) {
      _registerToken(apiClient, newToken, userRole);
    });

    // Foreground messages → show local notification
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // Notification tapped while app in background (but not killed)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  static String _fcmEndpoint(String role) => role == 'coach'
      ? '/coaches/me/fcm-token'
      : role == 'arbitre'
          ? '/referee/me/fcm-token'
          : '/players/me/fcm-token';

  Future<void> _registerToken(
      ApiClient apiClient, String token, String userRole) async {
    try {
      final endpoint = _fcmEndpoint(userRole);
      await apiClient.dio.put(endpoint, data: {'fcmToken': token});
      debugPrint('[FCM] Token registered with backend.');
    } catch (e) {
      debugPrint('[FCM] Token registration failed: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final type = message.data['type'] as String? ?? 'unknown';

    // Suppress chat notifications while the user is already viewing the chat
    if (type == 'chat_message' && isChatOpen) return;

    // Suppress if already shown via Socket.IO (avoid double-banner)
    if (type == 'chat_message') {
      final fcmId = notification.hashCode;
      if (_shownSocketNotifIds.contains(fcmId)) return;
    }

    // Respect user preference
    final enabled = await NotificationPrefsService.instance.isEnabled();
    if (!enabled) return;

    // Track count
    await NotificationPrefsService.instance.increment(type);

    // Encode the FCM data map as a simple key=value string so the tap
    // handler can reconstruct it from NotificationResponse.payload.
    final payload = message.data.entries.map((e) => '${e.key}=${e.value}').join(',');

    await _localNotif.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  /// Show a local notification banner for an incoming chat message.
  /// Called by ChatListPage when a Socket.IO message arrives while the user
  /// is on a different tab (foreground but not viewing chat).
  Future<void> showLocalChatNotification({
    required String messageId,
    required String senderName,
    required String messagePreview,
    String? teamId,
  }) async {
    // Respect user preference
    final enabled = await NotificationPrefsService.instance.isEnabled();
    if (!enabled) return;

    // Track count
    await NotificationPrefsService.instance.increment('chat_message');

    final payload = [
      'type=chat_message',
      if (teamId != null) 'teamId=$teamId',
    ].join(',');

    final notifId = messageId.hashCode;
    _shownSocketNotifIds.add(notifId);
    // Auto-remove after 5 s so the set doesn't grow unbounded
    Future.delayed(const Duration(seconds: 5), () => _shownSocketNotifIds.remove(notifId));

    await _localNotif.show(
      notifId,
      '💬 $senderName',
      messagePreview,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  /// Call when user disables notifications — removes token from backend
  Future<void> unregisterToken(ApiClient apiClient, {required String userRole}) async {
    try {
      final endpoint = _fcmEndpoint(userRole);
      await apiClient.dio.put(endpoint, data: {'fcmToken': null});
    } catch (_) {}
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('[FCM] Local notification tapped: ${response.payload}');
    if (response.payload == null || response.payload!.isEmpty) return;

    // Decode "key=value,key=value" payload back to a map
    final data = Map.fromEntries(
      response.payload!.split(',').map((pair) {
        final idx = pair.indexOf('=');
        if (idx < 0) return MapEntry(pair, '');
        return MapEntry(pair.substring(0, idx), pair.substring(idx + 1));
      }),
    );
    _dispatchTap(data);
  }

  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('[FCM] App opened from background notification: ${message.data}');
    final data = message.data.map((k, v) => MapEntry(k, v.toString()));
    _dispatchTap(data);
  }

  void _dispatchTap(Map<String, String> data) {
    if (onNotificationTap != null) {
      onNotificationTap!(data);
    }
  }
}
