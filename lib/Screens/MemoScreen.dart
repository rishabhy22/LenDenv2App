import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:se_len_den/BLoC/MemoBloc.dart';
import 'package:se_len_den/BLoC/RoutesBloc.dart';
import 'package:se_len_den/Models/Conversation.dart';
import 'package:se_len_den/Models/MemoResponse.dart';
import 'package:se_len_den/UIElements/MemoBubble.dart';
import 'package:se_len_den/utils/deviceSizing.dart';
import 'package:se_len_den/utils/support.dart';

class MemoScreen extends StatefulWidget {
  final String accessToken;
  final String userId;
  final Conversation conversation;

  MemoScreen({this.accessToken, this.userId, this.conversation});

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> with CommonPageDesign {
  ScrollController scrollController;
  final TextEditingController textEditingController = TextEditingController();
  String msg;
  int trans;
  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();
    MemoBloc().init();
    MemoBloc().connectAndListen(widget.accessToken);
    MemoBloc().joinConvo(widget.conversation.id);
  }

  @override
  void dispose() {
    MemoBloc().leaveConvo(widget.conversation.id);
    MemoBloc().dispose();

    super.dispose();
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.conversation.title,
                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 5.4)),
            Row(
              children: [
                for (int i = 0;
                    i < widget.conversation.participants.length;
                    ++i)
                  Text(
                      widget.conversation.participants[i] +
                          (i != widget.conversation.participants.length - 1
                              ? ","
                              : ""),
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 6))
              ],
            )
          ],
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            RoutesBloc()
                .setRoute(RouteWithData(route: Routes.DASHBOARD, data: null));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            decoration: bgDecoration(theme),
          )),
          Column(
            children: [
              Expanded(
                flex: 9,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.screenWidth * 0.06,
                      bottom: SizeConfig.screenWidth * 0.06),
                  child: StreamBuilder<JoinMemoResponse>(
                      stream: MemoBloc().getJoinMemoResponse,
                      builder: (context, joinSnapshot) {
                        return joinSnapshot.hasData
                            ? StreamBuilder<MemoResponse>(
                                stream: MemoBloc().getMemoResponse,
                                builder: (context, memoSnapshot) {
                                  if (memoSnapshot.hasData)
                                    joinSnapshot.data.memoList
                                        .add(memoSnapshot.data.memo);
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    if (scrollController.hasClients &&
                                        !memoSnapshot.hasData) {
                                      scrollController.jumpTo(
                                        scrollController
                                            .position.maxScrollExtent,
                                      );
                                    }
                                    if (memoSnapshot.hasData &&
                                        scrollController.hasClients) {
                                      scrollController.animateTo(
                                        scrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(milliseconds: 600),
                                        curve: Curves.ease,
                                      );
                                    }
                                  });

                                  return ListView.builder(
                                      controller: scrollController,
                                      physics: ClampingScrollPhysics(),
                                      itemCount:
                                          joinSnapshot.data.memoList.length,
                                      itemBuilder: (context, index) {
                                        var memo =
                                            joinSnapshot.data.memoList[index];
                                        // var dateTime = DateTime
                                        //     .fromMillisecondsSinceEpoch(
                                        //   (memo.sentTime * 1000).toInt(),
                                        // );
                                        // var date =
                                        //     "${dateTime.day}-${dateTime.month}-${dateTime.year}";
                                        var time = readTimestamp(
                                            (memo.sentTime * 1000).toInt());

                                        return CustomChatBubble(
                                          userId: widget.userId,
                                          memo: memo,
                                          time: time,
                                        );
                                      });
                                })
                            : Center(child: CircularProgressIndicator());
                      }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.024,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 8,
                          child: ChatBox(
                            onChanged: (value) {
                              msg = value;
                            },
                            textEditingController: textEditingController,
                          )),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            if (msg != null && msg.isNotEmpty) {
                              MemoBloc().sendMessage(
                                  memoType: "chat",
                                  msgType: "msg",
                                  convoId: widget.conversation.id,
                                  memo: msg);
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 600),
                                curve: Curves.ease,
                              );
                              textEditingController.clear();
                            }
                          },
                          child: CircleAvatar(
                            radius: SizeConfig.blockSizeHorizontal *
                                SizeConfig.blockSizeVertical *
                                3.6,
                            child: Icon(
                              Icons.send,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ChatBox extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController textEditingController;
  ChatBox({this.onChanged, this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          SizeConfig.blockSizeHorizontal * SizeConfig.blockSizeVertical * 4),
      child: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
            Icon(Icons.attach_money_rounded,
                size: 30.0, color: Theme.of(context).hintColor),
            SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
            Expanded(
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal),
          ],
        ),
      ),
    );
  }
}
