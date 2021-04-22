import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final String initialMsg;

  MemoScreen(
      {this.accessToken, this.userId, this.conversation, this.initialMsg});

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen>
    with CommonPageDesign, SingleTickerProviderStateMixin {
  ScrollController scrollController;
  final TextEditingController textEditingControllerTop =
      TextEditingController();
  final TextEditingController textEditingControllerBottom =
      TextEditingController();
  AnimationController animationController;
  String msg;
  int trans;
  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scrollController = ScrollController();
    MemoBloc().init();
    MemoBloc().connectAndListen(widget.accessToken);
    MemoBloc().joinConvo(widget.conversation.id);

    if (this.widget.initialMsg != null && this.widget.initialMsg.isNotEmpty) {
      MemoBloc().sendMessage(
          memoType: "chat",
          msgType: "msg",
          convoId: widget.conversation.id,
          memo: this.widget.initialMsg);
    }
  }

  @override
  void dispose() {
    MemoBloc().leaveConvo(widget.conversation.id);
    MemoBloc().dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        title: GestureDetector(
          onTap: () {
            RoutesBloc().setRoute(RouteWithData(
                route: Routes.CONVERSATIONPROFILE,
                data: [
                  this.widget.accessToken,
                  this.widget.userId,
                  this.widget.conversation
                ]));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.conversation.title,
                  style:
                      TextStyle(fontSize: SizeConfig.blockSizeVertical * 5.4)),
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
            LayoutBuilder(builder: (context, constraints) {
              return LimitedBox(
                maxHeight: constraints.maxHeight,
                child: Column(
                  children: [
                    LimitedBox(
                      maxHeight: constraints.maxHeight * 0.88,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.screenWidth * 0.02,
                            bottom: SizeConfig.screenWidth * 0.02),
                        child: StreamBuilder<JoinMemoResponse>(
                            stream: MemoBloc().getJoinMemoResponse,
                            initialData: JoinMemoResponse.fromJson({
                              "status": "success",
                              "error": null,
                              "data": []
                            }),
                            builder: (context, joinSnapshot) {
                              return joinSnapshot.hasData
                                  ? StreamBuilder<MemoResponse>(
                                      stream: MemoBloc().getMemoResponse,
                                      builder: (context, memoSnapshot) {
                                        if (memoSnapshot.hasData &&
                                            joinSnapshot
                                                .data.memoList.isNotEmpty &&
                                            memoSnapshot.data.memo.id !=
                                                joinSnapshot
                                                    .data.memoList.last.id) {
                                          joinSnapshot.data.memoList
                                              .add(memoSnapshot.data.memo);
                                        }
                                        if (memoSnapshot.hasData &&
                                            joinSnapshot
                                                .data.memoList.isEmpty) {
                                          joinSnapshot.data.memoList
                                              .add(memoSnapshot.data.memo);
                                        }
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
                                              duration:
                                                  Duration(milliseconds: 600),
                                              curve: Curves.ease,
                                            );
                                          }
                                        });

                                        return ListView.builder(
                                            controller: scrollController,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: joinSnapshot
                                                .data.memoList.length,
                                            itemBuilder: (context, index) {
                                              var memo = joinSnapshot
                                                  .data.memoList[index];
                                              // var dateTime = DateTime
                                              //     .fromMillisecondsSinceEpoch(
                                              //   (memo.sentTime * 1000).toInt(),
                                              // );
                                              // var date =
                                              //     "${dateTime.day}-${dateTime.month}-${dateTime.year}";
                                              var time = readTimestamp(
                                                  (memo.sentTime * 1000)
                                                      .toInt());

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
                                  textEditingControllerTop:
                                      textEditingControllerTop,
                                  animationController: animationController,
                                  textEditingControllerBottom:
                                      textEditingControllerBottom,
                                  iconButtonColor: theme.accentColor,
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
                                    // scrollController.animateTo(
                                    //   scrollController.position.maxScrollExtent,
                                    //   duration: Duration(milliseconds: 600),
                                    //   curve: Curves.ease,
                                    // );
                                    textEditingControllerTop.clear();
                                  }
                                },
                                child: CircleAvatar(
                                  radius: SizeConfig.blockSizeHorizontal *
                                      SizeConfig.blockSizeVertical *
                                      3.6,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.send,
                                    color: theme.accentColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: theme.primaryColor,
                    height: animationController.value *
                        SizeConfig.screenHeight *
                        0.3,
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          onPressed: () {
                            if (animationController.isCompleted)
                              animationController.reverse();
                            textEditingControllerBottom.clear();
                            FocusScope.of(context).unfocus();
                          })),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.25,
                          right: SizeConfig.screenWidth * 0.25),
                      child: TextField(
                        controller: textEditingControllerBottom,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeHorizontal * 10),
                        decoration: InputDecoration(
                          hintText: 'Enter Value',
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.blockSizeHorizontal * 10),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: theme.accentColor,
                                  width: SizeConfig.blockSizeVertical)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: theme.accentColor,
                                  width: SizeConfig.blockSizeVertical)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                              child: CircleAvatar(
                            radius: SizeConfig.blockSizeHorizontal * 15,
                            backgroundColor: Colors.red,
                            child: IconButton(
                                alignment: Alignment.center,
                                iconSize: SizeConfig.blockSizeVertical * 11,
                                icon: Icon(Icons.keyboard_arrow_up_rounded),
                                onPressed: () {
                                  if (textEditingControllerBottom.text !=
                                          null &&
                                      textEditingControllerBottom
                                          .text.isNotEmpty) {
                                    MemoBloc().sendMessage(
                                        memoType: "transaction",
                                        transType: -1,
                                        convoId: widget.conversation.id,
                                        memo: int.parse(
                                            textEditingControllerBottom.text));
                                    textEditingControllerBottom.clear();
                                  }
                                }),
                          )),
                          Expanded(
                            child: CircleAvatar(
                              radius: SizeConfig.blockSizeHorizontal * 15,
                              backgroundColor: Colors.green,
                              child: IconButton(
                                alignment: Alignment.center,
                                iconSize: SizeConfig.blockSizeVertical * 11,
                                icon: Icon(Icons.keyboard_arrow_down_rounded),
                                onPressed: () {
                                  if (textEditingControllerBottom.text !=
                                          null &&
                                      textEditingControllerBottom
                                          .text.isNotEmpty) {
                                    MemoBloc().sendMessage(
                                        memoType: "transaction",
                                        transType: 1,
                                        convoId: widget.conversation.id,
                                        memo: int.parse(
                                            textEditingControllerBottom.text));
                                    textEditingControllerBottom.clear();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    child: SizedBox(
                      height: SizeConfig.screenHeight * 0.05,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBox extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController textEditingControllerTop;
  final AnimationController animationController;
  final TextEditingController textEditingControllerBottom;
  final Color iconButtonColor;
  ChatBox(
      {this.onChanged,
      this.textEditingControllerTop,
      this.animationController,
      this.textEditingControllerBottom,
      this.iconButtonColor});
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
            IconButton(
              iconSize: SizeConfig.blockSizeHorizontal * 15,
              onPressed: () {
                if (animationController.isDismissed)
                  animationController.forward();
                textEditingControllerBottom.clear();
              },
              icon: Icon(Icons.attach_money_rounded, color: iconButtonColor),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
            Expanded(
              child: TextField(
                controller: textEditingControllerTop,
                decoration: InputDecoration(
                  hintText: 'Type a message',
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
