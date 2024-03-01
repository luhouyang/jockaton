import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/auth/auth_stream.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:macrohard/auth/auth_usecase.dart';
import 'package:macrohard/pages/main_page/navigation_usecase.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:macrohard/services/notification_service.dart';
import 'package:macrohard/services/user_usecase.dart';
import 'package:provider/provider.dart';
import 'package:torch_controller/torch_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  TorchController().initialize();

  await LocalNotificationService().init();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
      }
    });

    FirebaseMessaging.instance
        .getToken()
        .then((value) => {debugPrint("FCM Token Is: "), debugPrint(value)});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthUseCase(),
          ),
          ChangeNotifierProvider(
            create: (context) => CrazyRGBUsecase(),
          ),
          ChangeNotifierProvider(
            create: (context) => NavigationUseCase(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserUsecase(),
          ),
        ],
        child: MaterialApp(
          title: 'Water NOW!!!',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const AuthStream(),
        ));
  }
}
