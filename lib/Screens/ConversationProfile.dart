import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:se_len_den/BLoC/RoutesBloc.dart';
import 'package:se_len_den/Models/Conversation.dart';
import 'package:se_len_den/utils/deviceSizing.dart';
import 'package:se_len_den/utils/support.dart';

class ConversationProfile extends StatelessWidget with CommonPageDesign {
  final Conversation conversation;
  final String userId;
  final String accessToken;
  ConversationProfile({this.accessToken, this.userId, this.conversation});
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            decoration: bgDecoration(theme),
          )),
          Positioned.directional(
              textDirection: TextDirection.ltr,
              start: 0,
              top: SizeConfig.screenHeight * 0.11,
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.85,
              child: Column(
                children: [
                  Text(
                    "Title",
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(conversation.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: SizeConfig.blockSizeVertical * 7)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(conversation.desc,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.blockSizeVertical * 5)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                  Text(
                    "Participants",
                    style: TextStyle(color: Colors.white54),
                  ),
                  Expanded(
                      flex: 2,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          for (var i in conversation.participants)
                            Text(i,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.blockSizeVertical * 4))
                        ],
                      )),
                  Expanded(
                      flex: 3,
                      child: Text(
                          "Current due is Rs. 900. All dues will be settled if praddy and rishu pay you Rs. 900 each",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.blockSizeVertical * 5))),
                  Expanded(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Notify Everyone",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.blockSizeVertical * 5)),
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.arrow_forward_ios,
                            ),
                          )
                        ],
                      ))
                ],
              )),
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
                    RoutesBloc().setRoute(RouteWithData(
                        route: Routes.MEMO,
                        data: [
                          this.accessToken,
                          this.userId,
                          this.conversation
                        ]));
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ))
        ],
      ),
    );
  }
}
