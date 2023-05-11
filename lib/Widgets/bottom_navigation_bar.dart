import 'package:flutter/material.dart';
import 'package:quizish/Screens/homescreen.dart';

import '../Screens/join_screen.dart';

class PurpleNavigationBar extends Material {
  PurpleNavigationBar({
    Key? key,
    required VoidCallback onPressed,
}) : super(
    key: key,
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF7885b2),
      items: [
      const BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            label: 'Home'
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.quiz, color: Colors.black),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
          icon: Stack(alignment: Alignment.center,
          children: [
            Icon(Icons.radio_button_unchecked, size: 25, color: Colors.black,),
            Icon(Icons.workspaces_filled, size: 33, color: Colors.black)
          ],
          ),
            label: 'Join'
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite, color: Colors.black,),
          label: 'Favorite',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, color: Colors.black,),
          label: 'Account'
        ),
      ],
    )
  );
}

class NavigationBarOfTheme extends StatefulWidget {
  const NavigationBarOfTheme({Key? key}) : super(key: key);

  @override
  State<NavigationBarOfTheme> createState() => _NavigationBarOfThemeState();
}

class _NavigationBarOfThemeState extends State<NavigationBarOfTheme> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text("My Quizzes: Placeholder"),
    JoinScreen(),
    Text('Favorite: Placeholder'),
    Text('Account: Placeholder'),
    //QuizCreationScreen
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
            icon: Stack(alignment: Alignment.center,
              children: const [
                Icon(Icons.radio_button_unchecked, size: 25),
                Icon(Icons.workspaces_filled)
              ],
            ),
            label: 'Join'
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorite',
        ),
        const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account'
        ),
      ],
      onTap: _onItemTapped,
    );
}


}