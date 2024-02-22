import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailTextController = TextEditingController();
  var passTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        margin: const EdgeInsets.all(25.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue, width: 2.0),
            borderRadius: BorderRadius.circular(16.0)),
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
        child: Column(
          children: [
            inputTextWidget("email", emailTextController),
            inputTextWidget("password", passTextController),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                      text: TextSpan(
                          text: "forgot password?",
                          style: TextStyle(color: Colors.lightBlue[200]),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //TODO: send password reset email
                            }))
                ],
              ),
            ),
            Divider(color: Colors.blue[900], height: 2.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                const TextSpan(text: "Create a new account "),
                TextSpan(
                    text: "here",
                    style: TextStyle(color: Colors.lightBlue[200]),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //TODO: change to sign up
                      })
              ])),
            ),
          ],
        ),
      ),
    ));
  }

  Widget inputTextWidget(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
            fillColor: Colors.grey[200],
            focusColor: Colors.blue[200],
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blue[900])),
      ),
    );
  }
}
