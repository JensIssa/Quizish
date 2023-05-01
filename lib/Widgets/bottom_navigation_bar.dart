import 'package:flutter/material.dart';

class PurpleNavigationBar extends Material {
  PurpleNavigationBar({
    Key? key,
    required VoidCallback onPressed,
}) : super(
    key: key,
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.purpleAccent,
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