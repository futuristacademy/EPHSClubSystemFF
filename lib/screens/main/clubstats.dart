//import 'dart:html';
import 'package:flutter/material.dart';

class ClubStats extends StatefulWidget {
  @override
  _ClubStatsState createState() => _ClubStatsState();
}

class _ClubStatsState extends State<ClubStats> {
  @override
  void initState() {
    super.initState();
  }

  TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Icon(Icons.leaderboard, color: Colors.blue),
      title: Text('Coming Soon...',
          textAlign: TextAlign.left,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      subtitle: Text(
        'Development in progress',
        style: TextStyle(fontSize: 16),
      ),
      onTap: () => {},
    ));
  }
}
