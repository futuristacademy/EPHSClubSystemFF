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

    TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black54);

        final myImageAndCaption = [
      ["FA.jpg", "Futurist Academy"],
      ["quizbowl.png", "Quizbowl"],
      ["DECA.jpg", "DECA"],
      //["NHS.jpg", "NHS"],
    ];
        final settingsButton = Material(
      color: Colors.white,
      child: MaterialButton(
        onPressed: () {
          Navigator.pop(context);
          //settings popup
        },
        child: Text(
          "Settings",
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );

            final logoutButton = Material(
      color: Colors.white,
      child: MaterialButton(
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
        child: Text(
          "Log Out",
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );

        final joinClubButton = Material(
      color: Colors.white,
      child: MaterialButton(
        onPressed: () {
          Navigator.pop(context);
          //to join a club
        },
        child: Text(
          "Join Club",
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );

            final createClubButton = Material(
      color: Colors.white,
      child: MaterialButton(
        onPressed: () {
          Navigator.pop(context);
          //create a club
        },
        child: Text(
          "Create Club",
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );


    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Username's Dashboard"),
          actions: <Widget>[
            PopupMenuButton(
                color: Colors.white,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: logoutButton,
                      ),
                      PopupMenuItem(
                        child: settingsButton,
                      ),
                      PopupMenuItem(
                        child: joinClubButton,
                      ),
                      PopupMenuItem(
                        child: createClubButton,
                      ),
                    ],
                offset: Offset(0, 0)),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: GridView.count(
          crossAxisCount: 3,
          children: [
            ...myImageAndCaption.map(
              (i) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 3.0,
                    child: Image.asset(
                    i.first,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                 ),
                    
                  ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text(i.last,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  subtitle: Text(
                    '2021-2022',
                    style:
                        TextStyle(fontSize: 16),
                  ),
                  onTap: () => {},
                ),
              ),                
                ],
              ),
            ),
          ],
          ),
            ));
  }
}
