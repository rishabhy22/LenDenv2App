import 'package:flutter/material.dart';
import 'package:se_len_den/BLoC/ConnectionsBloc.dart';
import 'package:se_len_den/BLoC/RoutesBloc.dart';
import 'package:se_len_den/Models/Connection.dart';
import 'package:se_len_den/Models/OtherUser.dart';
import 'package:se_len_den/UIElements/ConnectionCard.dart';
import 'package:se_len_den/utils/deviceSizing.dart';
import 'package:se_len_den/utils/support.dart';

class ConnectionsScreen extends StatefulWidget {
  final String accessToken;
  final bool isUserEmailVerified;
  ConnectionsScreen({this.accessToken, this.isUserEmailVerified});

  @override
  _ConnectionsScreenState createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen>
    with CommonPageDesign, SingleTickerProviderStateMixin {
  AnimationController animationController;

  String value;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    super.initState();
  }

  @override
  void dispose() {
    if (animationController != null) animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            RoutesBloc()
                .setRoute(RouteWithData(route: Routes.DASHBOARD, data: null));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Connections",
          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 5.4),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.person_add_outlined,
              ),
              onPressed: () {
                if (animationController.isCompleted)
                  animationController.reverse();
                else
                  animationController.forward();
              })
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              decoration: bgDecoration(theme),
            )),
            FutureBuilder<List<Connection>>(
                future:
                    ConnectionsBloc().getConnections(this.widget.accessToken),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? (snapshot.data.length != 0
                          ? Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.02,
                              ),
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.screenWidth * 0.038,
                                          right:
                                              SizeConfig.screenWidth * 0.038),
                                      child: CustomCard(
                                        accessToken: this.widget.accessToken,
                                        otherUser: snapshot.data
                                            .elementAt(index)
                                            .otherUser,
                                        isUserEmailVerified:
                                            this.widget.isUserEmailVerified,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      thickness:
                                          SizeConfig.screenHeight * 0.001,
                                      color: Colors.white,
                                      indent: SizeConfig.screenWidth * 0.038,
                                      endIndent: SizeConfig.screenWidth * 0.038,
                                    );
                                  },
                                  itemCount: snapshot.data.length),
                            )
                          : Center(
                              child: Image.asset(
                              "assets/images/empty.png",
                              width: SizeConfig.screenWidth * 0.3,
                              height: SizeConfig.screenHeight * 0.2,
                              color: Colors.white,
                            )))
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }),
            AnimatedBuilder(
                animation: animationController,
                child: ListView(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.003,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.05,
                          right: SizeConfig.screenWidth * 0.05),
                      child: TextField(
                        style: theme.textTheme.bodyText1,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search_sharp),
                            onPressed: () {
                              setState(() {
                                value = textEditingController.text;
                              });
                            },
                          ),
                          isDense: true,
                          hintText: "Enter Username Here",
                          hintStyle: TextStyle(
                            fontSize: 2 *
                                SizeConfig.blockSizeVertical *
                                SizeConfig.blockSizeHorizontal,
                            height: 0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.04,
                          right: SizeConfig.screenWidth * 0.04,
                          bottom: SizeConfig.screenHeight * 0.01),
                      child: Divider(
                        color: Colors.black,
                        height: 0,
                        thickness: 1,
                      ),
                    ),
                    FutureBuilder<List<OtherUser>>(
                        initialData: List<OtherUser>.empty(),
                        future: ConnectionsBloc()
                            .fetchUsers(this.widget.accessToken, value),
                        builder: (context, snapshot) {
                          return LimitedBox(
                            maxHeight: SizeConfig.screenHeight * 0.4,
                            child: snapshot.hasData
                                ? (snapshot.data.length != 0
                                    ? ListView.builder(
                                        padding: EdgeInsets.only(
                                          left: SizeConfig.screenWidth * 0.04,
                                          right: SizeConfig.screenWidth * 0.04,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    SizeConfig.screenHeight *
                                                        0.01),
                                            child: CustomCard(
                                              accessToken:
                                                  this.widget.accessToken,
                                              otherUser: snapshot.data
                                                  .elementAt(index),
                                              isUserEmailVerified: this
                                                  .widget
                                                  .isUserEmailVerified,
                                            ),
                                          );
                                        },
                                        itemCount: snapshot.data.length,
                                      )
                                    : Center(
                                        child: Image.asset(
                                        "assets/images/empty.png",
                                        width: SizeConfig.screenWidth * 0.2,
                                        height: SizeConfig.screenHeight * 0.15,
                                        color: Colors.white,
                                      )))
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          );
                        })
                  ],
                ),
                builder: (context, child) {
                  return Container(
                      padding: EdgeInsets.zero,
                      color: theme.accentColor,
                      height: SizeConfig.screenHeight *
                          0.5 *
                          animationController.value,
                      child: child);
                })
          ],
        ),
      ),
    );
  }
}
