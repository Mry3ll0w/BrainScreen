import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brainscreen/main.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:flutter/material.dart';

class NotificationController {
  /// Callback para controlar que sucede cuando un usuario pulsa en la notificacion
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    navigatorKey.currentState
        ?.pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
  }
}
