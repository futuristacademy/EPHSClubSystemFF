import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:clubsystem/screens/main/dashboard.dart';
import 'package:clubsystem/screens/utility/global.dart';
import 'package:clubsystem/screens/utility/notifiers.dart';
import 'package:http/http.dart' as http;

//login template
class LoginTemplate extends StatefulWidget {
  LoginTemplate();

  @override
  State<LoginTemplate> createState() {
    return _LoginTemplateState();
  }
}

class _LoginTemplateState extends State<LoginTemplate> {
  //variables to change UI based on state

  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  //String _tier = "";

  bool _isLogginIn = false;

  _LoginTemplateState();

  //try executing the actual login process
  Future<String> executeLogin() async {
        Map<String, String> params = {
      'email': _email.text.trim(),
      'password': _password.text.trim()
    };
    var logindetails;

    //try {
    final response = await http.post(
        Uri.https('protected-tor-81595.herokuapp.com', 'user/login'),
        body: params,
        ).then((value) { 
          logindetails = value;
          if (logindetails.statusCode !=200 || logindetails.body == "Login Failed") {
            setState(() => _isLogginIn = false);
            print("ERROR SIGNING IN");
            print(logindetails.statusCode);
            // showDialog(
            // context: context,
            // builder: (context) {
            //   return SingleActionPopup(
            //       "Invalid Credentials", "Error", Colors.black);
            // });
          } else {
           Navigator.push(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
          }
        });
    print(logindetails.body);
    //final jsonMap = jsonDecode(logindetails.body);
    //
    // } on SocketException {
    //   setState(() => _isLogginIn = false);
    //           showDialog(
    //         context: context,
    //         builder: (context) {
    //           return ErrorPopup(
    //               "Network timed out, please check your wifi connection", () {
    //             Navigator.of(context).pop();
    //             setState(() {
    //               _isLogginIn = true;
    //             });
    //             executeLogin();
    //           });
    //         });
    // } on HttpException {
    //   setState(() => _isLogginIn = false);
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return SingleActionPopup(
    //               "Invalid Credentials", "Error", Colors.black);
    //         });
    // }
    return "did_stuff";
  }

  void tryToLogin() async {
    setState(() {
      _isLogginIn = true;
    });
    executeLogin();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return Stack(
      children: <Widget>[
        Container(
          width: screenWidth * 0.4,
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
                child: Container(
                  child: Text(
                    "Login",
                    style: new TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 20 * screenWidth / pixelTwoWidth,
                    ),
                  ),
                ),
              ),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15 * screenHeight / pixelTwoHeight),
                      child: Container(
                        width: screenWidth * 0.75,
                        //make this a TextField if using controller
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            if (val != "") {
                              setState(() {
                                _email.text = val;
                              });
                            }

                            bool dotIsNotIn = _email.text.indexOf(".") == -1;
                            bool atIsNotIn = _email.text.indexOf("@") == -1;

                            //validate email locally

                            if (dotIsNotIn || atIsNotIn) {
                              return "Invalid Email Type";
                            }

                            return null;
                          },
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.mail),
                            labelText: "E-mail",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.75,
                      //make this a TextField if using controller
                      child: TextFormField(
                        controller: _password,
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12 * screenWidth / pixelTwoWidth),
                        validator: (val) /* check whether the form is valid */ {
                          if (val == "") {
                            return "Field is empty";
                          }

                          setState(() {
                            _password.text = val;
                          });

                          //validate password length
                          bool hasLengthLessThan8 = _password.text.length < 8;

                          if (hasLengthLessThan8) {
                            return "Password less than 8";
                          }

                          return null;
                        },
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: new InputDecoration(
                            icon: Icon(Icons.lock), labelText: "Password"),
                      ),
                    ),
                    Padding(
                      padding: new EdgeInsets.all(
                          20.0 * screenHeight / pixelTwoHeight),
                      child: ButtonTheme(
                          minWidth: 100 * screenWidth / pixelTwoWidth,
                          height: screenHeight * 0.07,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              child: Text(
                                "Login",
                                style: new TextStyle(
                                    fontSize: 20 * screenWidth / pixelTwoWidth,
                                    fontFamily: 'Lato'),
                              ),
                            ),
                            onPressed: () => tryToLogin(),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isLogginIn)
          Container(
              width: screenWidth * 0.8,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.23),
                child: CircularProgressIndicator(),
              )),
      ],
    );
  }
}

//Register Template Class
class RegisterTemplate extends StatefulWidget {
  @override
  State<RegisterTemplate> createState() {
    return _RegisterTemplateState();
  }
}

class _RegisterTemplateState extends State<RegisterTemplate> {
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  //String _tier;
  bool _isTryingToRegister = false; //used to give progress bar animation
  bool isNameValid = false;

  final _registrationFormKey = GlobalKey<FormState>();

  //executes the actual registration
  void executeRegistration() async {
    Map<String, dynamic> newUserData = {
      "name": _firstName.text.trim()+" "+_lastName.text.trim(),
      "email": _email.text.trim(),
      "password": _password.text.trim(),
      //"access": "Basic",
    };
    var signupdetails;
      final response = await http.post(
        Uri.https('protected-tor-81595.herokuapp.com', 'user'),
        body: newUserData,
        ).then((value) { 
          signupdetails = value;
          if (signupdetails.statusCode !=200) {
            setState(() => _isTryingToRegister = false);
            print("ERROR SIGNING IN"); print("ERROR SIGNING IN"); 
            print(signupdetails.statusCode);
            // showDialog(
            // context: context,
            // builder: (context) {
            //   return SingleActionPopup(
            //       "Invalid Credentials", "Error", Colors.black);
            // });
          } else {
           Navigator.push(
          context, MaterialPageRoute(builder: (context) => new DashboardScreen()));
          }
        });
    print(signupdetails.body);
    //     try {
    // } on SocketException {
    //   setState(() => _isTryingToRegister = false);
    //           showDialog(
    //         context: context,
    //         builder: (context) {
    //           return ErrorPopup(
    //               "Network timed out, please check your wifi connection", () {
    //             Navigator.of(context).pop();
    //             setState(() {
    //               _isTryingToRegister = true;
    //             });
    //             executeRegistration();
    //           });
    //         });
    // } on HttpException {
    //   setState(() => _isTryingToRegister = false);
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return SingleActionPopup(
    //               "Invalid Credentials", "Error", Colors.black);
    //         });
    // }
    //   setState(() => _isTryingToRegister = false);

  }
      //catching invalid email error

  //handles registration of user
  void tryToRegister() async {
    //checking to make sure multiple attempts at registering doesn't occur
    if (!_isTryingToRegister) {
      setState(() => _isTryingToRegister = true);

      if (_registrationFormKey.currentState
          .validate()) /*check whether form is valid */ {
        executeRegistration();
      } else {
        setState(() => _isTryingToRegister = false);
      }
    }
  }

  Widget build(BuildContext context) {
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          width: screenWidth * 0.6,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: screenHeight / 45),
                child: Container(
                    child: Text("Register",
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20 * screenWidth / pixelTwoWidth))),
              ),
              new Form(
                  key: _registrationFormKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight / 60),
                        child: Container(
                          width: screenWidth * 0.75,
                          child: TextFormField(
                            controller: _firstName,
                            style: new TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12 * screenWidth / pixelTwoWidth),
                            textAlign: TextAlign.center,
                            decoration:
                                InputDecoration(labelText: "First Name"),
                            validator: (val) {
                              if (val == "") {
                                return "Field is empty";
                              }

                              setState(() => _firstName.text = val);

                              return null;
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.75,
                        child: TextFormField(
                          controller: _lastName,
                          style: new TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12 * screenWidth / pixelTwoWidth),
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            labelText: 'Last Name',
                          ),
                          validator: (val) {
                            if (val == "") {
                              return "Field is empty";
                            }
                            setState(() => _lastName.text = val);
                            return null;
                          },
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.75,
                        child: TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            if (val == "") {
                              return "Field is empty";
                            }
                            setState(() {
                              _email.text = val;
                            });

                            //validate email
                            bool dotIsNotIn = _email.text.indexOf(".") == -1;
                            bool atIsNotIn = _email.text.indexOf("@") == -1;

                            if (dotIsNotIn || atIsNotIn) {
                              return "Invalid Email Type";
                            }
                            return null;
                          },
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.mail),
                            labelText: "E-mail",
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.75,
                        child: TextFormField(
                          controller: _password,
                          style: new TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            //validate password
                            if (val == "") {
                              return "Field is empty";
                            }

                            setState(() {
                              _password.text = val;
                            });

                            bool hasLengthLessThan8 = _password.text.length < 8;

                            if (hasLengthLessThan8) {
                              return "Password less than 8";
                            }

                            return null;
                          },
                          textAlign: TextAlign.center,
                          obscureText: true,
                          decoration: new InputDecoration(
                              icon: Icon(Icons.lock), labelText: "Password"),
                        ),
                      ),
                      Padding(
                        padding: new EdgeInsets.all(screenHeight / 45),
                        child: ButtonTheme(
                            minWidth: 150.0,
                            height: screenHeight * 0.1,
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.blue[600],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Container(
                                child: Text(
                                  "Register",
                                  style: new TextStyle(
                                      fontSize:
                                          20 * screenWidth / pixelTwoWidth,
                                      fontFamily: 'Lato'),
                                ),
                              ),
                              onPressed: () => tryToRegister(),
                            )),
                      )
                    ],
                  )),
            ],
          ),
        ),
        if (_isTryingToRegister) //to add the progress indicator
          Container(
              width: screenWidth * 0.8,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.27),
                child: CircularProgressIndicator(),
              ))
      ],
    );
  }
}