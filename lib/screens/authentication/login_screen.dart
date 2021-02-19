import 'package:flutter/material.dart';
import 'package:vastermind/screens/authentication/sign_up_screen.dart';
import 'package:vastermind/services/AuthService.dart';
import 'package:vastermind/utilities/widgets.dart';
import '../../utilities/constants.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "login screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  String error = "";

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //login in the user
      try {
        await AuthService.login(_email, _password, context);
        error = "";
        Navigator.pop(context);
      }catch(e){
        setState(() {
          error = "No user found with such email or password";
        });
    }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height, //height of the whole entire screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Vastermind",
              style: TextStyle(
                fontSize: vLargeSizeText,
                fontFamily: 'TechnaSans',
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                error.isNotEmpty ? Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10 ),
                  child: Text(error, style: TextStyle(color: Colors.red, fontSize: smallSizeText),),
                ) : SizedBox(),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Email"),
                          validator: (input) =>
                          !input.contains("@") || !input.contains(".")
                              ? "Please enter a valid email"
                              : null,
                          onSaved: (input) => _email = input,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Password"),
                          validator: (input) => input.length < 8
                              ? "Please enter a valid password"
                              : null,
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
                              title: "Sign In",
                              buttonSize: "large",
                              top: 10
                          ),
                        ),
                      ),
                      ButtonNoFill(
                        title: "Don't have an account yet? back to Sign Up",
                        function: () =>
                            Navigator.pop(context),
                        textColor: lightBlue,
                        textSize: smallSizeText,
                      )

                    ],
                  ),
                ),

              ],
            )

          ],
        ),
      ),
    );
  }
}
