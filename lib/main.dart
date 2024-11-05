import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brainscreen/pages/controllers/notifications_controller.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/welcome.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure binding is initialized if not dependant async operantions wont be call correctly

  // Initialize Firebase with options
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
          channelGroupKey: 'error_channel_group',
          channelKey: 'error_channel',
          channelName: 'ErrorNotification',
          channelDescription: 'Notificacion de errores',
          ledColor: BrainColors.mainBannerColor)
    ], channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'error_channel_group',
          channelGroupName: 'error_channel_group')
    ]);

    // Comprobamos que tenemos permisos de notificar y lo solicitamos en caso contrario
    bool bIsNotificationsAllowed =
        await AwesomeNotifications().isNotificationAllowed();
    if (!bIsNotificationsAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  } else {
    await Firebase.initializeApp(
      name: 'BrainScreen',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Inicializa el .env
  }
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// CallBacks de AwesomeNotifications
  @override
  void initState() {
    // Inicializamos los listeners
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'SF'),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return const MaterialApp(
      home: WelcomeHome(),
    );
  }
}
