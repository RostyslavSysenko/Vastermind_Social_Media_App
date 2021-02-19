import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vastermind/screens/authentication/login_screen.dart';
import 'package:vastermind/services/AuthService.dart';
import 'package:vastermind/utilities/widgets.dart';
import '../../utilities/constants.dart';

class SignUpScreen extends StatefulWidget {
  static final String id = "signup screen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _name, _fullName;

  String errorMessage = "Success! You can now join the Vastermind";
  Color errorColor = Colors.green;

  _submit() async{
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (activated) {
        errorMessage = await AuthService.signUpUser(context, _name, _email, _password, _fullName);
        setState(() {
          errorMessage = errorMessage;
          errorColor = Colors.red;
        });
      } else {
        setState(() {
          activated = true;
        });
      }
    }
  }

  String secretCode = "iamawinner";
  bool activated = false;
  bool hasAccessCode = false;

  TextEditingController secretCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              activated
                  ? Text(
                      "Vastermind",
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'TechnaSans',
                      ),
                    )
                  : SizedBox(),
              Form(
                  key: _formKey,
                  child: activated && hasAccessCode
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30, top: 10 ),
                              child: Text(errorMessage, style: TextStyle(color: errorColor, fontSize: smallSizeText),),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 0),
                              child: TextFormField(
                                autocorrect: false,
                                decoration:
                                    InputDecoration(labelText: "Full Name"),
                                validator: (input) {
                                  if (activated) {
                                    if (input.trim().isEmpty) {
                                      return "Please enter your Full Name";
                                    } else
                                      return null;
                                  } else
                                    return null;
                                },
                                onSaved: (input) => _fullName = input,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Username"),
                                autocorrect: false,
                                validator: (input) {
                                  if (activated) {
                                    if (input.trim().isEmpty) {
                                      return "Please enter your username";
                                    } else
                                      return null;
                                  } else
                                    return null;
                                },
                                onSaved: (input) => _name = input,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: TextFormField(
                                autocorrect: false,
                                decoration: InputDecoration(labelText: "Email"),
                                validator: (input) {
                                  if (activated) {
                                    if (!input.contains("@") ||
                                        !input.contains(".")) {
                                      return "Please enter a valid email";
                                    } else
                                      return null;
                                  } else
                                    return null;
                                },
                                onSaved: (input) => _email = input,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Password"),
                                validator: (input) {
                                  if (activated) {
                                    if (input.length < 8) {
                                      return "Please enter a valid password";
                                    } else
                                      return null;
                                  } else
                                    return null;
                                },
                                onSaved: (input) => _password = input,
                                obscureText: true,
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                                child: FilledSecondaryButton(
                                    function: _submit,
                                    color: lightBlue,
                                    title: "Sign Up",
                                    buttonSize: "large",
                                    top: 10),
                              ),
                            ),
                          ],
                        )
                      : activated == false && hasAccessCode == true
                          ? Column(
                              children: [
                                Text(
                                  "Vastermind",
                                  style: TextStyle(
                                    fontSize: vLargeSizeText,
                                    fontFamily: 'TechnaSans',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: TextFormField(
                                    controller: secretCodeController,
                                    autocorrect: false,
                                      enableSuggestions: false,
                                      decoration: InputDecoration(
                                          labelText: "Secret Code"),
                                      validator: (input) {
                                        if (input.trim().toLowerCase() !=
                                            secretCode.trim().toLowerCase()) {
                                          return "Please enter a valid code";
                                        } else{
                                          secretCodeController.clear();
                                          return null;
                                        }
                                      }),
                                ),
                                Container(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 20, 30, 0),
                                    child: FilledSecondaryButton(
                                        function: _submit,
                                        color: lightBlue,
                                        title: "Verify Code",
                                        buttonSize: "large",
                                        top: 10),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "🎉Welcome!",
                                        style: TextStyle(
                                            color: grey,
                                            fontSize: largeSizeText,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(""),
                                      Text(
                                          "We're working hard to get Vastermind ready for launch! While we wrap up the finishing touches, we're adding people gradually to make sure nothing breaks. :)",
                                          style: TextStyle(
                                              color: grey,
                                              fontSize: midSizeText)),
                                      Text(""),
                                      Text(
                                          "So, for now only those with the secret code can register. If you don't have the secret code, we apologise for inconvenience and can't wait for you to join us in the near future! 🙏",
                                          style: TextStyle(
                                              color: grey,
                                              fontSize: midSizeText)),
                                      Text(""),
                                      Text(
                                        "🏠 Ross & the Vastermind team",
                                        style: TextStyle(
                                            color: grey, fontSize: midSizeText),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          child: FilledSecondaryButton(
                                              function: () {
                                                setState(() {
                                                  hasAccessCode = true;
                                                });
                                              },
                                              color: lightBlue,
                                              title: "Register With Secret Code",
                                              buttonSize: "large",
                                              top: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
              ButtonNoFill(
                title: "Already have an account? Sign In->",
                function: () => Navigator.pushNamed(context, LoginScreen.id),
                textColor: lightBlue,
                textSize: smallSizeText,
              )
            ],
          ),
        ),
      ),
    );
  }
}
