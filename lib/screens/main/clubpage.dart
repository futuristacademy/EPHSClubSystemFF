import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:clubsystem/screens/authentication/authentication_screen.dart';

class ClubPage extends StatefulWidget {
  ClubPage({Key key}) : super(key: key);

  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black54);

    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            Text(
              "List of Members",
              style: style,
            ),
            SizedBox(
              height: 500.0,
              width: 500.0,
              child: ListView(children: const <Widget>[
                //for member in memberlist{
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Student Name'),
                    subtitle: Text('Grade 12, Role: Captain'),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Student Name'),
                    subtitle: Text('Grade 12, Role: Officer'),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
                Card(
                    child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Student Name'),
                  subtitle: Text('Grade 11, Role: Member'),
                  trailing: Icon(Icons.more_vert),
                )),
              ]),
            )
          ]),
          Column(children: [
            Text(
              "General Club Information",
              style: style,
            ),
            SizedBox(
              height: 500.0,
              width: 500.0,
              child: ListView(children: const <Widget>[
                Card(
                    child: ListTile(
                  leading: Icon(Icons.class__sharp),
                  title: Text('Club Name'),
                  subtitle: Text('This club is about....(Description)'),
                  trailing: Icon(Icons.more_vert),
                )),
              ]),
            )
          ]),
        ]),
      )
    ]);
  }
}
