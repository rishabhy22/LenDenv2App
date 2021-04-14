import 'package:flutter/material.dart';
import 'package:se_len_den/Screens/Authentication/LoginPage.dart';
import 'package:se_len_den/Screens/Authentication/RegisterPage.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool isReg = false;

  static Tween<double> tween(double width) =>
      Tween<double>(begin: width, end: 0);
  void toggle(bool value) {
    setState(() {
      isReg = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 800),
      child: isReg
          ? RegisterPage(
              toggle: toggle,
            )
          : LoginPage(
              toggle: toggle,
            ),
    );
  }
}
