import 'package:flutter/material.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemedAppBar({
    Key key,
    this.title,
    this.backgroundColor,
  }) : super(key: key);
  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor == Colors.white ? Colors.black : Colors.white;
    return AppBar(
      brightness:
          backgroundColor == Colors.white ? Brightness.light : Brightness.dark,
      iconTheme: IconThemeData(color: color),
      backgroundColor: backgroundColor ?? const Color(0xff124570),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
