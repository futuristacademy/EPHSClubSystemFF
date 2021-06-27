import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:clubsystem/screens/authentication/authentication_screen.dart';
import 'package:clubsystem/screens/main/clubpage.dart';
import 'package:clubsystem/screens/main/attendance.dart';
import 'package:clubsystem/screens/main/playgame.dart';
import 'package:clubsystem/screens/main/clubstats.dart';

class MainSelect extends StatefulWidget {
  MainSelect({Key key}) : super(key: key);

  @override
  _MainSelectState createState() => _MainSelectState();
}

class _MainSelectState extends State<MainSelect> {
  int _selectedIndex = 1;

  void indexHome() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  Widget changeUI(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return Attendance();
      case 1:
        return ClubPage();
      case 2:
        return ClubStats();
        break;
      case 3:
        return PlayGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black54);

    final leaveClubButton = Material(
      color: Colors.white,
      child: MaterialButton(
        onPressed: () {
          Navigator.pop(context);
          //settings popup
        },
        child: Text(
          "Leave Club",
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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text((_selectedIndex == 1)
              ? "Club Name"
              : (_selectedIndex == 0)
                  ? "Attendance"
                  : (_selectedIndex == 3)
                      ? "Play Game"
                      : "Club Stats"),
          actions: <Widget>[
            PopupMenuButton(
                color: Colors.white,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: logoutButton,
                      ),
                      PopupMenuItem(
                        child: leaveClubButton,
                      ),
                    ],
                offset: Offset(0, 0)),
          ],
        ),
        body: changeUI(_selectedIndex), 
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          unselectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 40),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, size: 40),
            label: 'Club Page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 40),
            label: 'Club Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.games_mdi, size: 40),
            label: 'Play Game',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
        );
  }
}
