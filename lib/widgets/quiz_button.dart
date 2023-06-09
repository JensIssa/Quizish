import 'package:flutter/material.dart';

/**
 * A Material widget that is a button with a text in the center.
 */
class QuizButton extends Material {
  QuizButton({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    required Color color
    }) : super(
      key: key,
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
        ),
      ),
  );

}


