import 'package:flutter/material.dart';
import 'package:se_len_den/BLoC/AuthenticationBloc.dart';
import 'package:se_len_den/BLoC/RoutesBloc.dart';
import 'package:se_len_den/utils/deviceSizing.dart';
import 'package:se_len_den/utils/support.dart';

class CustomDrawer extends StatelessWidget with CommonPageDesign {
  final String imgUrl, accessToken, userId;

  CustomDrawer({this.imgUrl, this.accessToken, this.userId});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth * 0.65,
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              color: theme.primaryColor,
            )),
            Column(
              children: [
                Expanded(
                    flex: 2,
                    child: imgUrl != null
                        ? Image.network(
                            imgUrl.replaceFirst("127.0.0.1", "10.0.2.2"),
                            fit: BoxFit.fill,
                            headers: {
                              "Authorization": "Token ${this.accessToken}",
                              "Content-Type": "multipart/form-data"
                            },
                            height: SizeConfig.screenHeight * 0.25,
                            width: SizeConfig.screenWidth * 0.65,
                            cacheHeight:
                                (SizeConfig.screenHeight * 0.25).toInt(),
                            cacheWidth: (SizeConfig.screenWidth * 0.65).toInt(),
                          )
                        : Image.asset('assets/images/avatar.png')),
                Expanded(
                  flex: 3,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          RoutesBloc().setRoute(RouteWithData(
                              route: Routes.CONNECTIONS, data: null));
                        },
                        child: Text(
                          'Connections',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 5 * SizeConfig.blockSizeVertical),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                      ),
                      GestureDetector(
                        onTap: () {
                          RoutesBloc().setRoute(RouteWithData(
                              route: Routes.ADDCONVERSATION,
                              data: [this.accessToken, this.userId]));
                        },
                        child: Text(
                          'Add Conversation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 5 * SizeConfig.blockSizeVertical),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                      ),
                      Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 5 * SizeConfig.blockSizeVertical),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        AuthBloc().signOut();
                      },
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
