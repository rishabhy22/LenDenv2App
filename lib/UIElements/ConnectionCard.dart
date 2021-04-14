import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:se_len_den/BLoC/RoutesBloc.dart';
import 'package:se_len_den/Models/OtherUser.dart';
import 'package:se_len_den/UIElements/ClippedContainer.dart';
import 'package:se_len_den/utils/deviceSizing.dart';

class CustomCard extends StatelessWidget {
  final OtherUser otherUser;
  final String accessToken;
  bool isUserEmailVerified;
  CustomCard({this.accessToken, this.otherUser, this.isUserEmailVerified});
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ClippedButton(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        tileColor: theme.primaryColor,
        onTap: () {
          RoutesBloc().setRoute(RouteWithData(
              route: Routes.CONNECTIONPROFILE,
              data: [
                this.accessToken,
                this.otherUser,
                this.isUserEmailVerified
              ]));
        },
        leading: Padding(
          padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.1),
          child: otherUser.imageUrl == null
              ? Image.asset('assets/images/avatar.jpg')
              : Image.network(
                  otherUser.imageUrl.replaceAll("127.0.0.1", "10.0.2.2"),
                  fit: BoxFit.fill,
                  headers: {
                    "Authorization": "Token ${this.accessToken}",
                    "Content-Type": "multipart/form-data",
                    "Connection": "keep-alive"
                  },
                  width: SizeConfig.screenWidth * 0.15,
                  isAntiAlias: true,
                ),
        ),
        isThreeLine: true,
        dense: true,
        title: Text(
          otherUser.id,
          style: theme.textTheme.bodyText1,
        ),
        subtitle: Text(otherUser.firstName + ' ' + otherUser.lastName,
            style: theme.textTheme.subtitle2),
      ),
    );
  }
}
