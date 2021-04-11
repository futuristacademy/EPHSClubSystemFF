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

  bool _desiresAutoLogin = false;
  bool _isLogginIn = false;

  _LoginTemplateState();

  Future<String> login() async {
    Map<String, String> params = {
      'email': _email.text.trim(),
      'password': _password.text.trim()
    };
    final response = await http.post(
        Uri.https('protected-tor-81595.herokuapp.com', 'user/login'),
        body: params,
        headers: {
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        }
    );
    return response.toString();
  }

  //try executing the actual login process
  Future<String> executeLogin() async {
    String response;
    await login();
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim())
        .then((authResult) async /*sign in callback */ {
      String userId =
          authResult.user.uid;

      //changes screen to dashboard screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new DashboardScreen()));
    }).catchError((error) {
      print(error);

      setState(() => _isLogginIn = false);
      //if credentials are invalid then throw the error
      if (error.toString().contains("INVALID") ||
          error.toString().contains("WRONG") ||
          error.toString().contains("NOT_FOUND")) {
        showDialog(
            context: context,
            builder: (context) {
              return SingleActionPopup(
                  "Invalid Credentials", "Error", Colors.black);
            });
      }

      //if network times out, throw error
      else if (error.toString().contains("NETWORK")) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorPopup(
                  "Network timed out, please check your wifi connection", () {
                Navigator.of(context).pop();
                setState(() {
                  _isLogginIn = true;
                });
                executeLogin();
              });
            });
      }
    });
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

  Future<String> authenticateUser() async {
    String newUid;
    UserCredential authRes = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim());
    newUid = authRes.user.uid;

    //cache results

    //basic user information
    Map jsonInformation = {
      'auto': true,
      'email': _email.text,
      'password': _password.text,
      //'tier': _tier,
    } as Map;

    Global.uid = newUid;

    //create new document with data

    Map<String, dynamic> updatedUserData = {
      "first_name": _firstName.text.trim(),
      "email": _email.text.trim(),
      "last_name": _lastName.text.trim(),
      "access": "Basic",
      "uid": newUid,
    };

    return "Finished";
  }

  //executes the actual registration
  void executeRegistration() async {

    await authenticateUser()
        .then((_) /* call back for creating a users document*/ {
      setState(() => _isTryingToRegister = false);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DashboardScreen())); //go to profile screen

      //catching invalid email error
    }).catchError((error) {
      setState(() => _isTryingToRegister = false);

      //if email already exists throw an error popup
      if (error.toString().contains("ALREADY")) {
        showDialog(
            context: context,
            builder: (context) {
              return SingleActionPopup(
                  "Email is already in use", "ERROR!", Colors.blue);
            });
      }

      //catch a network timed out error
      if (error.toString().contains("NETWORK")) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorPopup(
                  "Network timed out, please check your wifi connection", () {
                Navigator.of(context).pop();
                setState(() {
                  _isTryingToRegister = true;
                });
                executeRegistration();
              });
            });
      }
       else {
        showDialog(
            context: context,
            builder: (context) {
              print(error);
              return ErrorPopup(
                  "Oof. Something went wrong during registration.", () {
                Navigator.of(context).pop();
                setState(() {
                  _isTryingToRegister = true;
                });
                executeRegistration();
              });
            });
       }
    });
  }

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