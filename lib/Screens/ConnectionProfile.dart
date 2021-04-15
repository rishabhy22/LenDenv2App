import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:se_len_den/BLoC/ConnectionsBloc.dart';
import 'package:se_len_den/BLoC/RoutesBloc.dart';
import 'package:se_len_den/Models/OtherUser.dart';
import 'package:se_len_den/utils/deviceSizing.dart';
import 'package:se_len_den/utils/support.dart';

class ConnectionProfile extends StatelessWidget with CommonPageDesign {
  final OtherUser otherUser;
  final String accessToken;
  final bool isUserEmailVerified;
  ConnectionProfile(
      {this.accessToken, this.otherUser, this.isUserEmailVerified});
  @override
  Widget build(BuildContext context) {
    print(isUserEmailVerified);
    var theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              top: SizeConfig.screenHeight * 0.3,
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight * 0.7,
                decoration: bgDecoration(theme),
              )),
          Column(
            children: [
              Container(
                height: SizeConfig.screenHeight * 0.3,
                width: SizeConfig.screenWidth,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.05,
                    right: SizeConfig.screenWidth * 0.05,
                    bottom: SizeConfig.screenHeight * 0.02),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.none,
                        image: otherUser.imageUrl != null
                            ? NetworkImage(
                                otherUser.imageUrl
                                        .replaceFirst("127.0.0.1", "10.0.2.2") +
                                    "?small=0",
                                headers: {
                                    "Authorization":
                                        "Token ${this.accessToken}",
                                    "Content-Type": "multipart/form-data",
                                    "Connection": "keep-alive"
                                  })
                            : AssetImage('assets/images/avatar.png'))),
                child: Text(
                  otherUser.firstName + ' ' + otherUser.lastName,
                  style: TextStyle(
                      fontSize: 5 *
                          SizeConfig.blockSizeHorizontal *
                          SizeConfig.blockSizeVertical,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(2.2 *
                    SizeConfig.blockSizeHorizontal *
                    SizeConfig.blockSizeVertical),
                leading: Icon(
                  Icons.alternate_email_sharp,
                  color: Colors.white,
                  size: 0.04 * SizeConfig.screenHeight,
                ),
                title: Text(
                  otherUser.id,
                  style: TextStyle(
                      fontSize: 3 *
                          SizeConfig.blockSizeHorizontal *
                          SizeConfig.blockSizeVertical,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Username",
                    style: TextStyle(
                        fontSize: 1.6 *
                            SizeConfig.blockSizeHorizontal *
                            SizeConfig.blockSizeVertical,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold)),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(
                    left: 2.2 *
                        SizeConfig.blockSizeHorizontal *
                        SizeConfig.blockSizeVertical),
                leading: Icon(
                  Icons.email_rounded,
                  color: Colors.white,
                  size: 0.04 * SizeConfig.screenHeight,
                ),
                title: Text(
                  otherUser.email,
                  style: TextStyle(
                      fontSize: 3 *
                          SizeConfig.blockSizeHorizontal *
                          SizeConfig.blockSizeVertical,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Email",
                    style: TextStyle(
                        fontSize: 1.6 *
                            SizeConfig.blockSizeHorizontal *
                            SizeConfig.blockSizeVertical,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.06,
              ),
              Row(
                children: [
                  otherUser.alreadyConnected
                      ? SizedBox()
                      : Expanded(
                          child: IconButton(
                          icon: Icon(
                            Icons.group_add_sharp,
                            color: Colors.white,
                            size: 0.04 * SizeConfig.screenHeight,
                          ),
                          onPressed: () async {
                            var status = await ConnectionsBloc()
                                .setConnection(accessToken, otherUser.id);
                            if (status.status == "success" &&
                                status.statusCode == 200) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "Connection Added",
                                  style: theme.textTheme.subtitle2,
                                ),
                                backgroundColor: theme.primaryColor,
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                  },
                                ),
                              ));
                            }
                            if (status.status != "success") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  status.error,
                                  style: theme.textTheme.subtitle2,
                                ),
                                backgroundColor: theme.primaryColor,
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                  },
                                ),
                              ));
                            }
                          },
                        )),
                  isUserEmailVerified
                      ? Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.add_comment,
                                color: Colors.white,
                                size: 0.04 * SizeConfig.screenHeight,
                              ),
                              onPressed: () {}))
                      : SizedBox()
                ],
              )
            ],
          ),
          Positioned.directional(
              textDirection: TextDirection.ltr,
              start: SizeConfig.screenWidth * 0.05,
              top: SizeConfig.screenHeight * 0.01,
              width: SizeConfig.screenWidth * 0.1,
              height: SizeConfig.screenHeight * 0.1,
              child: AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    RoutesBloc().setRoute(
                        RouteWithData(route: Routes.CONNECTIONS, data: null));
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ))
        ],
      ),
    );
  }
}
