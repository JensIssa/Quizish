import 'package:flutter/material.dart';

class InGameAppBar extends AppBar {

  InGameAppBar({Key? key, required VoidCallback onLeave, List<Widget>? actions})
      : super(key: key, title: Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 32, ),
    actions: [
      IconButton(
        onPressed: onLeave,
        icon: const Icon(Icons.exit_to_app),
        tooltip: 'Exit'
      ),
      ]
    );


}