import 'package:flutter/material.dart';

class BuildTextformfield extends StatefulWidget {
  const BuildTextformfield({
    super.key,
    required this.hint,
    this.validator,
    this.isPassword = false,
    this.isNumber = false,
    this.controller,
  });
  final String hint;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool isNumber;
  final TextEditingController? controller;

  @override
  State<BuildTextformfield> createState() => _BuildTextformfieldState();
}

class _BuildTextformfieldState extends State<BuildTextformfield> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.isNumber ? TextInputType.number : null,

      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.black),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  _obscureText = !_obscureText;
                  setState(() {});
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ),
    );
  }
}
