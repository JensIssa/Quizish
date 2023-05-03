import 'package:flutter/material.dart';

class PurpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;

  const PurpleAppBar({
    Key? key,
    required this.title,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: backgroundColor,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
