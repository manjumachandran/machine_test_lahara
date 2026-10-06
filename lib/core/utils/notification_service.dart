import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:machine_test_lahara/core/utils/app_navigator.dart';
import 'package:machine_test_lahara/features/posts/data/models/post_model.dart';
import 'package:machine_test_lahara/features/posts/presentation/pages/post_details_page.dart';


class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static int? _pendingPostId;

 
  static bool get _isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static const _androidDetails = AndroidNotificationDetails(
    'posts_channel',
    'Posts',
    channelDescription: 'Notifications for posts you asked to be notified about',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const _iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentSound: true,
  );

  static Future<void> init() async {
    if (!_isSupported) return; 

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) =>
          _openPost(_parseId(response.payload)),
    );

    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _pendingPostId = _parseId(launch!.notificationResponse?.payload);
    }
  }

  static Future<bool> requestPermission() async {
    if (!_isSupported) return false;

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission(); 
      return await android.areNotificationsEnabled() ?? false;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
              alert: true, badge: true, sound: true) ??
          false;
    }
    return false;
  }

  static Future<bool> showPostNotification(PostModel post) async {
    if (!_isSupported) return false;
    if (!await requestPermission()) return false;

    await _plugin.show(
      id: post.id,
      title: post.title,
      body: 'Post ID: ${post.id}',
      notificationDetails: const NotificationDetails(
        android: _androidDetails,
        iOS: _iosDetails,
      ),
      payload: jsonEncode({'id': post.id, 'title': post.title}),
    );
    return true;
  }

  static void handleLaunchNotification() {
    final id = _pendingPostId;
    if (id == null) return;

    if (navigatorKey.currentState == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => handleLaunchNotification());
      return;
    }
    _pendingPostId = null;
    _push(id);
  }

  static void _openPost(int? id) {
    if (id == null) return;
    if (navigatorKey.currentState == null) {
      _pendingPostId = id;
      return;
    }
    _push(id);
  }

  static void _push(int id) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => PostDetailsPage(id: id)),
    );
  }

  static int? _parseId(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      return (map['id'] as num?)?.toInt();
    } catch (_) {
      return int.tryParse(payload);
    }
  }
}