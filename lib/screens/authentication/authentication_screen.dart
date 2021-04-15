import 'dart:html';
import 'package:flutter/material.dart';
import 'package:clubsystem/screens/main/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubsystem/screens/main/templates.dart';
import 'package:clubsystem/screens/utility/util_widgets.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isTryingToLoad = false;

//with popups auth
  final _loginFormKey = GlobalKey<FormState>();

  bool _isLoginButtonClicked = false;
  bool _isRegisterButtonClicked = false;

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _desiresAutoLogin = false;
  bool _isLogginIn = false;
  bool isAdmin = false;

  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black);

  void createNewLoginTemplate() {
    setState(() {
      _isLoginButtonClicked = true;
      _isRegisterButtonClicked = false;
    });
  }

  void createNewRegisterTemplate() {
    setState(() {
      _isRegisterButtonClicked = true;
      _isLoginButtonClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        onPressed: createNewLoginTemplate,
        child: Text("Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black),
            ),
      ),
    );

    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        onPressed: createNewRegisterTemplate,
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: style,
      ),
    ));

    return Container(
        color: Colors.blue,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                    child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Spacer(flex: 1),
                                Text(
                                  "EPHS Club System",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                // Form(
                                //     key: _formKey,
                                //     child: Column(
                                //       children: <Widget>[
                                //         Padding(
                                //           padding: EdgeInsets.only(
                                //               top: 15.0,
                                //               right: 30.0,
                                //               left: 30.0),
                                //           child: SizedBox(child: emailField),
                                //         ),
                                //         Padding(
                                //           padding: EdgeInsets.only(
                                //               top: 15.0,
                                //               right: 30.0,
                                //               left: 30.0),
                                //           child: SizedBox(child: passwordField),
                                //         ),
                                //       ],
                                //     )),
                              ]),
                        ),
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15.0, right: 30.0, left: 30.0),
                                child: SizedBox(
                                  child: loginButton,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15.0, right: 30.0, left: 30.0),
                                child: SizedBox(
                                  child: signupButton,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                )),
              ),
              if (_isLoginButtonClicked)
                CurvedPopup(
                    child: new LoginTemplate(),
                    removePopup: () => setState(() {
                          _isLoginButtonClicked = false;
                        })),
              if (_isRegisterButtonClicked)
                CurvedPopup(
                    child: new RegisterTemplate(),
                    removePopup: () => setState(() {
                          _isRegisterButtonClicked = false;
                        })),
              if (_isTryingToLoad) //to add the progress indicator
                Stack(
                  children: [
                    GestureDetector(
                        child: Container(
                      color: Colors.black45,
                      width: screenWidth,
                      height: screenHeight,
                    )),
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: GestureDetector(
                            child: Stack(
                              children: [
                                Text(
                                  "Loading... Please Wait",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                LinearProgressIndicator(),
                              ],
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ));
  }
}
