import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/bloc/AppBloc.dart';
import 'package:quizish/bloc/AppEvent.dart';

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
      actions: [
        IconButton(onPressed: () {
          context.read<AppBloc>().add(AppLogOutRequested());
        }, icon: const Icon(Icons.exit_to_app))
      ],
      centerTitle: true,
      backgroundColor: backgroundColor,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
