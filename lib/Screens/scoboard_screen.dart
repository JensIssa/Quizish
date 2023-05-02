import 'package:flutter/material.dart';

class LeaderboardData {
  final String name;
  final int score;

  LeaderboardData(this.name, this.score);
}

final leaderboardData = [
  LeaderboardData('Rasmus', 1000),
  LeaderboardData('Jens', 900),
  LeaderboardData('Jakob', 800),
  LeaderboardData('Andreas', 700),
  LeaderboardData('Andy', 600),
  LeaderboardData('Mathias', 500),
  LeaderboardData('Søren', 400),
  LeaderboardData('Henrik', 300),
  LeaderboardData('Jeppe', 200),
  LeaderboardData('Alex', 100),
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
              tileColor: index == 0 ? Colors.yellow[400]: index == 1 ? Colors.black12 : index == 2 ? Colors.brown : index % 2 == 0 ? Colors.grey[800] : Colors.grey[700],
            );
          },
        ),
      ),
    );
  }
}
