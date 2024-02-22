import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/auth/firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var inEmailTextController = TextEditingController();
  var inPassTextController = TextEditingController();
  var upEmailTextController = TextEditingController();
  var upPassTextController = TextEditingController();

  bool _isSignIn = true;

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
        child: _isSignIn
            ? Column(
                children: [
                  inputTextWidget("email", emailVerify, inEmailTextController),
                  inputTextWidget("password", passwordVerify, inPassTextController),
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
                                    if (inEmailTextController.text.isNotEmpty) {
                                      FirebaseAuthServices().forgotPassword(
                                          context, inEmailTextController.text);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.blue[200],
                                          duration:
                                              const Duration(milliseconds: 700),
                                          content: const Text(
                                            "Enter your email",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      );
                                    }
                                  }))
                      ],
                    ),
                  ),
                  inputButtonWidget(() async {
                    await FirebaseAuthServices().signIn(context,
                        inEmailTextController.text, inPassTextController.text);
                  }, "Sign In"),
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
                              _isSignIn = !_isSignIn;
                            })
                    ])),
                  ),
                ],
              )
            : Column(
                children: [
                  inputTextWidget("email", emailVerify, upEmailTextController),
                  inputTextWidget("password", passwordVerify, upPassTextController),
                  inputButtonWidget(() async {
                    await FirebaseAuthServices().signUp(context,
                        inEmailTextController.text, inPassTextController.text);
                  }, "Sign Up"),
                  Divider(color: Colors.blue[900], height: 2.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: RichText(
                        text: TextSpan(children: <TextSpan>[
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                          text: "login",
                          style: TextStyle(color: Colors.lightBlue[200]),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _isSignIn = !_isSignIn;
                            })
                    ])),
                  ),
                ],
              ),
      ),
    ));
  }

  String emailVerify(value) {
    return EmailValidator.validate(value ?? "") ? "" : "Please enter a valid email";
  }

  String passwordVerify(value) {
    return value != null ? "" : "Please enter a valid email";
  }

  Widget inputTextWidget(
      String hint, Function validator, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: TextFormField(
        validator: (value) => validator(value),
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

  Widget inputButtonWidget(Function function, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: ElevatedButton(
        onPressed: () => function,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5.0),
          elevation: 10,
          shadowColor: Colors.grey,
          backgroundColor: Colors.green[600],
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.blue[900], fontSize: 24),
        ),
      ),
    );
  }
}
