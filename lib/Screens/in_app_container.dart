import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/Screens/account_screen.dart';
import 'package:tuple/tuple.dart';
import '../Widgets/animated_indexed_stack.dart';
import '../bloc/AppBloc.dart';
import '../bloc/AppEvent.dart';
import 'homescreen.dart';
import 'join_screen.dart';

class InAppContainer extends StatefulWidget {
  const InAppContainer({Key? key}) : super(key: key);

  @override
  State<InAppContainer> createState() => _InAppContainerState();
}

class _InAppContainerState extends State<InAppContainer> {
  int _selectedIndex = 0;

  static final List<Tuple2<Widget, Text>> _widgetOptions = [
    Tuple2(HomeScreen(), Text('Home')),
    Tuple2(Placeholder(), Text("My Quizzes: Placeholder")),
    Tuple2(JoinScreen(), Text('Join Quiz')),
    Tuple2(Placeholder(), Text("Favorites: Placeholder")),
    Tuple2(AccountDetails(), Text("Update your account details")),
    //QuizCreationScreen
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _widgetOptions[_selectedIndex].item2,
          actions: [
            IconButton(onPressed: () {
              context.read<AppBloc>().add(AppLogOutRequested());
            }, icon: const Icon(Icons.exit_to_app))
          ],

        ),
      body: AnimatedIndexedStack(
        duration: const Duration(milliseconds: 200),
        index: _selectedIndex,
        children: _widgetOptions.map((e) => e.item1).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

}
