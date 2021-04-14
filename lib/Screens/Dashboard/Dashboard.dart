import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:se_len_den/BLoC/ConversationsBLoc.dart';
import 'package:se_len_den/Models/Conversation.dart';
import 'package:se_len_den/Models/User.dart';
import 'package:se_len_den/Screens/Dashboard/Chats.dart';
import 'package:se_len_den/UIElements/ClippedContainer.dart';
import 'package:se_len_den/UIElements/Drawer.dart';
import 'package:se_len_den/utils/deviceSizing.dart';

import 'package:se_len_den/utils/support.dart';

class Dashboard extends StatefulWidget {
  final User user;
  Dashboard({this.user});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with CommonPageDesign {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Timer timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!this.widget.user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 6),
          content: Text(
            "You are not Email Verified. Check ${widget.user.email}",
            style: Theme.of(context).textTheme.subtitle2,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            label: 'Send Again',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ));
      }
    });

    timer = Timer.periodic(Duration(seconds: 20), (t) {
      setState(() {
        print("Polling event");
      });
    });
  }

  @override
  void dispose() {
    if (timer != null && timer.isActive) {
      print("Polling cancel");
      timer.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
        key: scaffoldKey,
        drawer: CustomDrawer(
          imgUrl: widget.user.profilePicUrl,
          accessToken: widget.user.accessToken,
        ),
        body: Stack(
          children: [
            Positioned.fill(
                child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              decoration: bgDecoration(theme),
            )),
            FutureBuilder<List<Conversation>>(
                future: ConvoBloc().getConvo(this.widget.user.accessToken),
                builder: (context, snapshot) {
                  print(jsonEncode(snapshot.data));
                  return snapshot.hasData
                      ? CustomScrollView(
                          physics: BouncingScrollPhysics(),
                          slivers: [
                            SliverAppBar(
                              backgroundColor: Colors.transparent,
                              floating: true,
                              pinned: false,
                              leading: IconButton(
                                icon: Icon(Icons.sort),
                                onPressed: () {
                                  scaffoldKey.currentState.openDrawer();
                                },
                              ),
                              expandedHeight: SizeConfig.screenHeight * 0.022,
                            ),
                            SliverAppBar(
                              backgroundColor: Colors.transparent,
                              floating: false,
                              pinned: false,
                              primary: false,
                              expandedHeight: SizeConfig.screenHeight * 0.34,
                              automaticallyImplyLeading: false,
                              flexibleSpace: Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.screenWidth * 0.05,
                                    right: SizeConfig.screenWidth * 0.05),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Recents",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(
                                        height: SizeConfig.screenHeight * 0.022,
                                      ),
                                      SizedBox(
                                        height: SizeConfig.screenHeight * 0.34,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      SizeConfig.screenHeight *
                                                          0.03),
                                              child: ClippedButton(
                                                child: Container(
                                                  color: Colors.white,
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.065,
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: 3,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SliverAppBar(
                              titleSpacing: SizeConfig.screenHeight * 0.02,
                              automaticallyImplyLeading: false,
                              title: Text(
                                "Chats",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                              backgroundColor: Colors.transparent,
                              floating: false,
                              pinned: true,
                              primary: false,
                            ),
                            CustomSliverList(
                              accessToken: this.widget.user.accessToken,
                              userId: this.widget.user.userId,
                              conversations: snapshot.data,
                            )
                          ],
                        )
                      : Center(child: CircularProgressIndicator());
                }),
          ],
        ));
  }
}
