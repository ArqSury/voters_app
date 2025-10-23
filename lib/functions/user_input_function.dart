import 'package:flutter/material.dart';

class UserInputFunction extends StatefulWidget {
  const UserInputFunction({
    super.key,
    required this.hint,
    this.isPassword = false,
    this.isNumber = false,
    this.inputType,
    this.textController,
    this.textValidator,
  });
  final String hint;
  final bool isPassword;
  final bool isNumber;
  final TextInputType? inputType;
  final TextEditingController? textController;
  final String? Function(String?)? textValidator;

  @override
  State<UserInputFunction> createState() => _UserInputFunctionState();
}

class _UserInputFunctionState extends State<UserInputFunction> {
  final bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.isNumber ? widget.inputType : null,
      obscureText: widget.isPassword ? _obscureText : false,
      controller: widget.textController,
      validator: widget.textValidator,
      decoration: InputDecoration(
        hintText: widget.hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
    );
  }
}
