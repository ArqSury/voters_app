import 'package:flutter/material.dart';

class ButtonFunction extends StatefulWidget {
  const ButtonFunction({
    super.key,
    this.pressButton,
    required this.buttonText,
    required this.buttonWidth,
    required this.buttonHeight,
    this.backgroundColor,
    this.color,
  });
  final void Function()? pressButton;
  final String buttonText;
  final double buttonWidth;
  final double buttonHeight;
  final Color? backgroundColor;
  final Color? color;

  @override
  State<ButtonFunction> createState() => _ButtonFunctionState();
}

class _ButtonFunctionState extends State<ButtonFunction> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.pressButton,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
        backgroundColor: widget.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        widget.buttonText,
        style: TextStyle(
          color: widget.color,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
