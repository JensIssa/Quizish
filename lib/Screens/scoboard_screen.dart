import 'package:flutter/material.dart';
import 'package:quizish/widgets/Appbar.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard'),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            color: Colors.white, thickness: 3.0, height: 5,
          ),
          itemCount: leaderboardData.length,
          itemBuilder: (context, index) {
            final data = leaderboardData[index];
            return ListTile(
              leading: Text(
                '${index + 1}',
                style: TextStyle(fontSize: 20.0),
              ),
              title: Text(data.name, style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text('${data.score}', style: TextStyle(fontSize: 20.0)),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              tileColor: index == 0 ? _tileColor(context, 0.9): index == 1 ? _tileColor(context, 0.6) : index == 2 ? _tileColor(context, 0.3) : index % 2 == 0 ? _tileColor(context, 0) : _tileColor(context, 0),
            );
          },
        ),
    );
  }

  _tileColor(BuildContext context, double opacity) {
    return Theme.of(context).colorScheme.secondary.withOpacity(opacity);
  }

}
