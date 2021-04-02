import 'package:flutter/material.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemedAppBar({
    Key key,
    this.title,
    this.actions,
    this.backgroundColor,
  }) : super(key: key);
  final String title;
  final Color backgroundColor;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor == Colors.white ? Colors.black : Colors.white;
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: color),
      backgroundColor: backgroundColor,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
