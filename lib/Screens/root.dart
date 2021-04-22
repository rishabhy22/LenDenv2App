import 'dart:convert';

import 'package:se_len_den/BLoC/AuthenticationBloc.dart';
import 'package:se_len_den/Models/AuthResponse.dart';
import 'package:se_len_den/Preferences/UserPreferences.dart';
import 'package:se_len_den/Screens/AfterAuthWrapper.dart';
import 'package:se_len_den/Screens/Authentication/Authentication.dart';
import 'package:flutter/material.dart';

import 'package:se_len_den/utils/deviceSizing.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    AuthBloc().verifyToken();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return StreamBuilder<AuthResponse>(
        stream: AuthBloc().getAuth,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("Auth event : " + jsonEncode(snapshot.data));
            UserPreferences.setUserPreference(snapshot.data.user);
            if (snapshot.data.user != null) {
              return AfterAuthWrapper(
                user: snapshot.data.user,
              );
            }
          }

          return AuthenticationWrapper();
        });
  }
}
