import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:macrohard/auth/auth_usecase.dart';
import 'package:macrohard/auth/login_page.dart';
import 'package:macrohard/pages/main_page/main_page.dart';
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
              return const MainPage();
            } else if (value.isLoading) {
              {
                double maxHeight = MediaQuery.of(context).size.height;
                double maxWidth = MediaQuery.of(context).size.width;
                int dis = 40;

                return Stack(
                  children: [
                    Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      size: 100,
                    )),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.hexagonDots(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.beat(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.bouncingBall(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.discreteCircle(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.dotsTriangle(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.fallingDot(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.flickr(
                          rightDotColor: Colors.red,
                          leftDotColor: Colors.blue,
                          size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.halfTriangleDot(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.hexagonDots(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.inkDrop(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.newtonCradle(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.prograssiveDots(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.stretchedDots(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.threeArchedCircle(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.threeRotatingDots(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.twistingDots(
                          rightDotColor: Colors.red,
                          leftDotColor: Colors.blue,
                          size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.twoRotatingArc(
                          color: Colors.blue, size: 75),
                    ),
                    Positioned(
                      top: Random().nextDouble() * maxHeight - dis,
                      left: Random().nextDouble() * maxWidth - dis,
                      child: LoadingAnimationWidget.waveDots(
                          color: Colors.blue, size: 75),
                    ),
                  ],
                );
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
