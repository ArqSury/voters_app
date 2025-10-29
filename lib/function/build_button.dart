import 'package:flutter/material.dart';

class BuildButton extends StatefulWidget {
  const BuildButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.width,
    required this.height,
    this.backgroundColor,
    this.color,
    this.fontSize,
  });
  final String text;
  final void Function()? onPressed;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? color;
  final double? fontSize;

  @override
  State<BuildButton> createState() => _BuildButtonState();
}

class _BuildButtonState extends State<BuildButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(fontSize: widget.fontSize, color: widget.color),
        ),
      ),
    );
  }
}
