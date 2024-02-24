import 'package:flutter/material.dart';
import 'package:macrohard/auth/auth_stream.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:macrohard/auth/auth_usecase.dart';
import 'package:macrohard/pages/main_page/navigation_usecase.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          ChangeNotifierProvider(create: (context) => NavigationUseCase(),),
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
