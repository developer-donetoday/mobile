import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const RectangleButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8.0),
            Text(text),
          ],
        ),
      ),
    );
  }
}
