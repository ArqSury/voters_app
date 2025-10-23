import 'package:flutter/material.dart';

class DrawerFunction extends StatefulWidget {
  const DrawerFunction({super.key});

  @override
  State<DrawerFunction> createState() => _DrawerFunctionState();
}

class _DrawerFunctionState extends State<DrawerFunction> {
  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}
