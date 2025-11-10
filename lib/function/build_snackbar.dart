import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';

class BuildSnackbar extends StatefulWidget {
  const BuildSnackbar({super.key, required this.text});
  final String text;

  @override
  State<BuildSnackbar> createState() => _BuildSnackbarState();
}

class _BuildSnackbarState extends State<BuildSnackbar> {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: AppColor.secondary,
      content: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/logo/logo_voterson_nobg.png',
            ),
          ),
          SizedBox(width: 12),
          Text(widget.text),
        ],
      ),
    );
  }
}
