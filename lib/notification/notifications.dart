import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';


// 自定义Notification action点击回调，暂时用不上
// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   // ignore: avoid_print
//   print('notification(${notificationResponse.id}) action tapped: '
//       '${notificationResponse.actionId} with'
//       ' payload: ${notificationResponse.payload}');
//   if (notificationResponse.input?.isNotEmpty ?? false) {
//     // ignore: avoid_print
//     print('notification action tapped with input: ${notificationResponse.input}');
//   }
// }

typedef ResponseCallback = void Function(NotificationResponse response);

/// flutter notification 管理工具
/// 基于flutter_local_notification封装
/// 主要提供工具方法
class LocalNotificationManager {
  LocalNotificationManager._internal();

  static String defaultAndroidChannelId = "default";
  static String defaultAndroidChannelName = "default channel";

  static final List<NotificationResponse> _cachedResponses = [];
  static ResponseCallback? _responseCallback;

  /// 初始化方法
  /// [androidIconResName] Android平台Notification展示icon，必须在android项目res/drawable目录下存在
  /// [notificationTapBackground] 自定义Notification action点击回调, 需要为顶级方法（不依赖class）且拥有{@pragma('vm:entry-point')}注解
  static Future<void> init({
    required String androidIconResName,
    DidReceiveBackgroundNotificationResponseCallback? notificationTapBackground
  }) async {
    // 从通知点击冷启动的情况下获取notification内携带的信息
    final launchDetails = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();
    if (launchDetails != null) {
      var coldLaunchResponse = launchDetails.notificationResponse;
      if (coldLaunchResponse != null) {
        pushMessageResponse(coldLaunchResponse);
      }
    }
    var androidInitSetting = AndroidInitializationSettings(
      androidIconResName
    );
    const iOSInitSetting = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    var initSettings = InitializationSettings(
      android: androidInitSetting,
      iOS: iOSInitSetting,
    );
    await FlutterLocalNotificationsPlugin().initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        pushMessageResponse(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  /// 注册通知点击回调
  static void registerResponseListener(ResponseCallback responseCallback) {
    _responseCallback = responseCallback;
    _handleCachedResponses();
  }

  /// 解除所有通知点击回调注册，关闭通知下发事件流
  static void unregisterResponseListener() {
    _responseCallback = null;
  }

  /// 推送message点击回调，用于处理外部通知点击事件转换至本系统内回调
  static void pushMessageResponse(NotificationResponse response) {
    if (_responseCallback == null) {
      _cachedResponses.add(response);
    }
    else {
      _responseCallback?.call(response);
    }
  }

  /// 清除未处理的缓存推送消息
  static void clearUnhandledResponses() {
    _cachedResponses.clear();
  }

  /// 缓存信息回调
  static Future<void> _handleCachedResponses() async {
    for (var resp in _cachedResponses) {
      _responseCallback?.call(resp);
    }
    _cachedResponses.clear();
  }

  /// 创建通知渠道
  /// [channel] 渠道配置对象
  static Future<void> createAndroidNotificationChannel({
    required AndroidNotificationChannel channel
  }) async {
    var plugin = FlutterLocalNotificationsPlugin();
    await plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }


  /// 按规则生成Notification Id
  /// 当前规则为取毫秒时间戳后6位
  static int generateNotificationId() {
    var currentTimeMills = DateTime.now().millisecondsSinceEpoch;
    return currentTimeMills % 1000;
  }

  /// 发送纯文本Notification
  /// [content] Notification内容描述，必填项
  /// [payload] Notification点击后发送给app的信息，必填项
  /// [notificationId] Notification Id，在取消通知或者更新通知时需要使用，不传则自动生成
  /// [androidChannelId] Android平台通知渠道Id，不传使用默认值
  /// [androidChannelName] Android平台通知渠道名称，不传使用默认值
  static Future<void> sendSimpleNotification({
    required String content,
    required String payload,
    int? notificationId,
    String title = "app_name",
    String? androidChannelId,
    String? androidChannelName,
  }) async {
    var androidNotificationDetails = AndroidNotificationDetails(
      androidChannelId ?? defaultAndroidChannelId,
      androidChannelName ?? defaultAndroidChannelName,
    );
    var iosDetails = DarwinNotificationDetails(

    );
    var notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosDetails
    );
    await FlutterLocalNotificationsPlugin().show(
        notificationId ?? generateNotificationId(),
        title,
        content,
        notificationDetails,
        payload: payload
    );
  }

  static Future<void> cancelNotification(int notificationId) async {
    await FlutterLocalNotificationsPlugin().cancel(notificationId);
  }

  static Future<void> cancelAllNotifications() async {
    await FlutterLocalNotificationsPlugin().cancelAll();
  }

  static Future<bool> requestPermission() async {
    bool? result;
    if (Platform.isIOS) {
      result = await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true,);
    }
    if (Platform.isAndroid) {
      result = await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    return result ?? false;
  }

  static Future<bool> hasPermission() async {
    if (Platform.isIOS) {
      var checkResult = await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()?.checkPermissions();
      return checkResult?.isEnabled ?? false;
    }
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;
      return status == PermissionStatus.granted;
    }
    return false;
  }
}