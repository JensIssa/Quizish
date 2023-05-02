import 'package:flutter/material.dart';

class LeaderboardData {
  final String name;
  final int score;

  LeaderboardData(this.name, this.score);
}

final leaderboardData = [
  LeaderboardData('Rasmus', 100),
  LeaderboardData('Jens', 200),
  LeaderboardData('Jakob', 300),
  LeaderboardData('Andreas', 400),
  LeaderboardData('Andy', 500),
  LeaderboardData('Mathias', 600),
  LeaderboardData('Søren', 700),
  LeaderboardData('Henrik', 800),
  LeaderboardData('Jeppe', 900),
  LeaderboardData('Alex', 1000),
];

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        accentColor: Colors.blue,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard'),
        ),
        body: ListView.builder(
          itemCount: leaderboardData.length,
          itemBuilder: (context, index) {
            final data = leaderboardData[index];
            return ListTile(
              leading: Icon(Icons.emoji_events, color: Colors.amber),
              title: Text(data.name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Score: ${data.score}', style: TextStyle(fontSize: 18.0)),
              trailing: Text('${index + 1}', style: TextStyle(fontSize: 20.0)),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              tileColor: index % 2 == 0 ? Colors.grey[800] : Colors.grey[700],
            );
          },
        ),
      ),
    );
  }
}
