import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Instancia de Firebase Messaging
  final _firebaseMessagin = FirebaseMessaging.instance;

  /// Funcion para inicializar la instancia de mensajeria de firebase
  /// Solicita al usuario permisos para poder notificar
  Future<void> initNotification() async {
    // permisos de notificacion
    await _firebaseMessagin.requestPermission();
    // Pillamos el token FCM
    final fcmToken = await _firebaseMessagin.getToken();

    //Mostramos el token
    print('Notification FCM token $fcmToken');
  }
}
