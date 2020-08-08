import 'package:flutter/material.dart';

class MessagingUtils {
  static void showErrorMessage(String message,
      {GlobalKey<ScaffoldState> scaffoldKey, BuildContext context}) {
    final scaffold = scaffoldKey?.currentState ?? Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }
}
