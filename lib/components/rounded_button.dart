import 'package:flutter/material.dart';

/// [title] and [onPressed] are required.
/// [title] is a String to be shown as button caption
/// [onPressed] is a callback to be run when button pressed
/// [color] is the color of the button, defaults to red.
///
class RoundedButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;
  final double vpad;
  final double radius;
  final double width;
  final double height;

  RoundedButton({
    @required this.title,
    @required this.onPressed,
    this.color = Colors.red,
    this.vpad = 16.0,
    this.radius = 30.0,
    this.width = 200.0,
    this.height = 42.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vpad),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(radius),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: width,
          height: height,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
