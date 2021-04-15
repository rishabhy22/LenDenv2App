import 'package:flutter/material.dart';
import 'package:se_len_den/BLoC/RoutesBloc.dart';
import 'package:se_len_den/Models/User.dart';
import 'package:se_len_den/Screens/AddConversation.dart';
import 'package:se_len_den/Screens/Authentication/Authentication.dart';
import 'package:se_len_den/Screens/ConnectionProfile.dart';
import 'package:se_len_den/Screens/Connections.dart';
import 'package:se_len_den/Screens/ConversationProfile.dart';
import 'package:se_len_den/Screens/Dashboard/Dashboard.dart';
import 'package:se_len_den/Screens/MemoScreen.dart';

class AfterAuthWrapper extends StatelessWidget {
  final User user;
  AfterAuthWrapper({this.user});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RouteWithData>(
        stream: RoutesBloc().getRoute,
        initialData: RouteWithData(route: Routes.DASHBOARD, data: null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.route) {
              case Routes.DASHBOARD:
                return Dashboard(
                  user: this.user,
                );
              case Routes.CONNECTIONS:
                return ConnectionsScreen(
                  accessToken: this.user.accessToken,
                  isUserEmailVerified: this.user.emailVerified,
                );
              case Routes.CONVERSATIONS:
                return Container();
              case Routes.AUTH:
                return AuthenticationWrapper();
              case Routes.CONNECTIONPROFILE:
                return ConnectionProfile(
                  accessToken: snapshot.data.data[0],
                  otherUser: snapshot.data.data[1],
                  isUserEmailVerified: snapshot.data.data[2],
                );
              case Routes.ADDCONVERSATION:
                return AddConversation(
                  accessToken: this.user.accessToken,
                  userId: this.user.userId,
                );
              case Routes.MEMO:
                return MemoScreen(
                  accessToken: snapshot.data.data[0],
                  userId: snapshot.data.data[1],
                  conversation: snapshot.data.data[2],
                );
              case Routes.CONVERSATIONPROFILE:
                return ConversationProfile(
                  accessToken: snapshot.data.data[0],
                  userId: snapshot.data.data[1],
                  conversation: snapshot.data.data[2],
                );
            }
          }
          return Container();
        });
  }
}
