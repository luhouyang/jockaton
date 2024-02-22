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
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 150, 25, 150),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.lightBlue, width: 1.0),
            borderRadius: BorderRadius.circular(32.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
                offset: Offset(4, 8), // Shadow position
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          child: _isSignIn
              ? Column(
                  children: [
                    Text("SIGN IN", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 36),),
                    const SizedBox(height: 30,),
                    inputTextWidget(
                        "email", emailVerify, inEmailTextController),
                    inputTextWidget(
                        "password", passwordVerify, inPassTextController),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: "forgot password?",
                                  style:
                                      TextStyle(color: Colors.lightBlue[200]),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (inEmailTextController
                                          .text.isNotEmpty) {
                                        FirebaseAuthServices().forgotPassword(
                                            context,
                                            inEmailTextController.text);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.blue[200],
                                            duration: const Duration(
                                                milliseconds: 700),
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
                      await FirebaseAuthServices().signIn(
                          context,
                          inEmailTextController.text,
                          inPassTextController.text);
                    }, "SIGN IN"),
                    Divider(color: Colors.blue[900], height: 2.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                        const TextSpan(
                            text: "Create a new account ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: "Here",
                            style: TextStyle(color: Colors.lightBlue[200]),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _isSignIn = !_isSignIn;
                                setState(() {});
                              })
                      ])),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Text("SIGN UP", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 36),),
                    const SizedBox(height: 30,),
                    inputTextWidget(
                        "email", emailVerify, upEmailTextController),
                    inputTextWidget(
                        "password", passwordVerify, upPassTextController),
                    inputButtonWidget(() async {
                      await FirebaseAuthServices().signUp(
                          context,
                          inEmailTextController.text,
                          inPassTextController.text);
                    }, "SIGN UP"),
                    Divider(color: Colors.blue[900], height: 2.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                        const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: "Login",
                            style: TextStyle(color: Colors.lightBlue[200]),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _isSignIn = !_isSignIn;
                                setState(() {});
                              })
                      ])),
                    ),
                  ],
                ),
        ),
      ),
    ));
  }

  String emailVerify(value) {
    return EmailValidator.validate(value ?? "")
        ? ""
        : "Please enter a valid email";
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
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            fillColor: Colors.grey[200],
            focusColor: Colors.blue[200],
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blue[900])),
      ),
    );
  }

  Widget inputButtonWidget(Function function, String text) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
            child: ElevatedButton(
              onPressed: () => function(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(5.0),
                elevation: 5,
                shadowColor: Colors.grey,
                backgroundColor: Colors.tealAccent,
              ),
              child: Text(
                text,
                style: TextStyle(color: Colors.blue[900], fontSize: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
