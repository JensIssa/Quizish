import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LeaderboardData {
  final String name;
  final int score;

  LeaderboardData(this.name, this.score);
}

final leaderboardData = [
  LeaderboardData('John', 100),
  LeaderboardData('Jane', 200),
  LeaderboardData('Jack', 300),
  LeaderboardData('Jill', 400),
  LeaderboardData('James', 500),
  LeaderboardData('Jenny', 600),
  LeaderboardData('Jared', 700),
  LeaderboardData('Jasmine', 800),
  LeaderboardData('Jasper', 900),
  LeaderboardData('Jade', 1000),
];
class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final data = leaderboardData[index];
          return ListTile(
            title: Text(data.name),
            subtitle: Text('Score: ${data.score}'),
          );
        },
      ),
    );
  }
}
