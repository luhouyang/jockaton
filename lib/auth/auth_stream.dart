import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:macrohard/auth/auth_usecase.dart';
import 'package:macrohard/auth/login_page.dart';
import 'package:macrohard/pages/home_page.dart';
import 'package:provider/provider.dart';

class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthUseCase>(
          builder: (context, value, child) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Stack(
                    children: [
                      LoadingAnimationWidget.discreteCircle(
                          color: Colors.blue, size: 40.0),
                    ],
                  );
                } else if (snapshot.hasData) {
                  return const HomePage();
                } else if (value.isLoading) {
                  {
                    return Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      size: 100,
                    ));
                  }
                } else {
                  return const LoginPage();
                }
              },
            );
          },
        );
  }
}
