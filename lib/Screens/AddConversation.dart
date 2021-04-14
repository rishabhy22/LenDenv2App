import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:se_len_den/BLoC/ConnectionsBloc.dart';
import 'package:se_len_den/BLoC/ConversationsBLoc.dart';
import 'package:se_len_den/BLoC/RoutesBloc.dart';
import 'package:se_len_den/Models/Connection.dart';
import 'package:se_len_den/Models/OtherUser.dart';
import 'package:se_len_den/UIElements/ClippedContainer.dart';
import 'package:se_len_den/utils/deviceSizing.dart';
import 'package:se_len_den/utils/support.dart';

class AddConversation extends StatefulWidget {
  final String accessToken;
  AddConversation({this.accessToken});
  @override
  _AddConversationState createState() => _AddConversationState();
}

class _AddConversationState extends State<AddConversation>
    with CommonPageDesign, SingleTickerProviderStateMixin {
  AnimationController animationController;
  final topKey = GlobalKey<AnimatedListState>();
  final bottomKey = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
  }

  String titleValidator(String value) {
    if (value == null) return 'Title cannot be null';
    if (value.isEmpty) return 'Title cannot be empty';
    return null;
  }

  bool validate = false, isLoading = false;
  List<Connection> ids = List<Connection>.empty(growable: true);
  List<Connection> connections;
  String title, desc;
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
          "Add Conversation",
          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 5.4),
        ),
      ),
      body: SingleChildScrollView(
        child: LimitedBox(
          maxHeight: SizeConfig.screenHeight * 0.9,
          child: GestureDetector(
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenWidth * 0.06,
                        right: SizeConfig.screenWidth * 0.06),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                        TextField(
                          style: theme.textTheme.bodyText1,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Conversation Title",
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              height: 0,
                              color: Colors.white,
                            ),
                            errorText: validate ? titleValidator(title) : null,
                            errorStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onChanged: (value) {
                            title = value;
                          },
                        ),
                        Divider(
                          color: Colors.black,
                          height: 0,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                        TextField(
                          style: theme.textTheme.bodyText1,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Conversation Description",
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              height: 0,
                              color: Colors.white,
                            ),
                          ),
                          onChanged: (value) {
                            desc = value;
                          },
                        ),
                        Divider(
                          color: Colors.black,
                          height: 0,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.04,
                        ),
                        Text("Add Participants"),
                        IconButton(
                            onPressed: () {
                              if (animationController.isCompleted)
                                animationController.reverse();
                              else
                                animationController.forward();
                            },
                            icon: Icon(Icons.add_box)),
                        LimitedBox(
                          maxHeight: SizeConfig.screenHeight * 0.5,
                          child: AnimatedList(
                            key: topKey,
                            itemBuilder: (context, index, animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset(0, 0),
                                ).animate(animation),
                                child: ListTile(
                                  title: Text(
                                    ids[index].otherUser.id,
                                    style: theme.textTheme.bodyText1,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.remove_circle_sharp,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        connections.add(ids[index]);

                                        print(connections.length);
                                        topKey.currentState.removeItem(
                                          index,
                                          (context, animation) => ListTile(
                                              title: Text(
                                                "",
                                                style:
                                                    theme.textTheme.bodyText1,
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(
                                                  Icons.remove_circle_sharp,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {},
                                              ),
                                              contentPadding: EdgeInsets.only(
                                                  left: SizeConfig.screenWidth *
                                                      0.06,
                                                  right:
                                                      SizeConfig.screenWidth *
                                                          0.06)),
                                        );
                                        ids.removeAt(index);
                                        bottomKey.currentState.insertItem(
                                            connections.length == 0
                                                ? 0
                                                : (connections.length - 1));
                                      });
                                    },
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * 0.06,
                                      right: SizeConfig.screenWidth * 0.06),
                                ),
                              );
                            },
                            initialItemCount: ids.length,
                          ),
                        ),
                        !isLoading
                            ? IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  if (titleValidator(title) == null) {
                                    setState(() {
                                      validate = false;
                                      isLoading = true;
                                    });
                                    if (ids.isNotEmpty) {
                                      List<String> participants =
                                          List<String>.empty(growable: true);

                                      for (var id in ids) {
                                        participants.add(id.otherUser.id);
                                      }
                                      var status = await ConvoBloc().setConvo(
                                          widget.accessToken,
                                          title,
                                          participants,
                                          desc);
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
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "Success",
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
                                        await Future.delayed(
                                            Duration(milliseconds: 500));
                                        RoutesBloc().setRoute(RouteWithData(
                                            route: Routes.MEMO, data: null));
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "Participants cannot be empty",
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
                                  } else {
                                    setState(() {
                                      validate = true;
                                    });
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                })
                            : CircularProgressIndicator(
                                backgroundColor: theme.primaryColor,
                              )
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                      animation: animationController,
                      child: FutureBuilder<List<Connection>>(
                          future: ConnectionsBloc()
                              .getConnections(this.widget.accessToken),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (connections == null)
                                connections = snapshot.data;
                              return (snapshot.data.length != 0
                                  ? AnimatedList(
                                      key: bottomKey,
                                      itemBuilder: (context, index, animation) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(-1, 0),
                                            end: Offset(0, 0),
                                          ).animate(animation),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.screenWidth *
                                                      0.038,
                                                  right:
                                                      SizeConfig.screenWidth *
                                                          0.038,
                                                  bottom:
                                                      SizeConfig.screenHeight *
                                                          0.01),
                                              child: ClippedButton(
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .screenWidth *
                                                              0.1),
                                                  tileColor: theme.accentColor,
                                                  title: Text(
                                                      connections[index]
                                                          .otherUser
                                                          .id,
                                                      style: theme
                                                          .textTheme.bodyText1),
                                                  subtitle: Text(
                                                      connections[index]
                                                              .otherUser
                                                              .firstName +
                                                          ' ' +
                                                          connections[index]
                                                              .otherUser
                                                              .lastName,
                                                      style: theme
                                                          .textTheme.bodyText1),
                                                  onTap: () {
                                                    setState(() {
                                                      ids.add(connections
                                                          .elementAt(index));

                                                      bottomKey.currentState
                                                          .removeItem(
                                                              index,
                                                              (context,
                                                                      animation) =>
                                                                  SlideTransition(
                                                                    position: Tween<
                                                                        Offset>(
                                                                      begin:
                                                                          const Offset(
                                                                              -1,
                                                                              0),
                                                                      end: Offset(
                                                                          0, 0),
                                                                    ).animate(
                                                                        animation),
                                                                    child:
                                                                        ClippedButton(
                                                                      child:
                                                                          ListTile(
                                                                        tileColor:
                                                                            theme.accentColor,
                                                                      ),
                                                                    ),
                                                                  ));
                                                      connections
                                                          .removeAt(index);
                                                      topKey.currentState
                                                          .insertItem(
                                                              ids.length - 1);

                                                      print("Ids :" +
                                                          ids.length
                                                              .toString());
                                                      print("cons :" +
                                                          connections.length
                                                              .toString());
                                                    });
                                                  },
                                                ),
                                              )),
                                        );
                                      },
                                      initialItemCount: snapshot.data.length)
                                  : Center(
                                      child: Image.asset(
                                      "assets/images/empty.png",
                                      width: SizeConfig.screenWidth * 0.3,
                                      height: SizeConfig.screenHeight * 0.2,
                                      color: Colors.white,
                                    )));
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                      builder: (context, child) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: animationController.value *
                                SizeConfig.screenHeight *
                                0.5,
                            color: theme.primaryColor,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * 0.02),
                              child: child,
                            ),
                          ),
                        );
                      })
                ],
              )),
        ),
      ),
    );
  }
}
