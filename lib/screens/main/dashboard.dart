import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:clubsystem/screens/authentication/authentication_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {

         final logoutButton = Container(
        alignment: Alignment.center,
        child: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            //logout user request to database
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => new AuthScreen(),
              ),
              (route) => false,
            );
          },
        ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Username's Dashboard"),
        actions: <Widget>[
          PopupMenuButton(
              color: Colors.blueGrey,
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: logoutButton,
                    ),
                  ],
              offset: Offset(0, 0)),
        ],
      ),
      );
  }
}
