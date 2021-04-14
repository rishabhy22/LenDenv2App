import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:se_len_den/Models/Memo.dart';
import 'package:se_len_den/utils/deviceSizing.dart';

class CustomChatBubble extends StatelessWidget {
  final Memo memo;
  final String userId, time;

  CustomChatBubble({this.userId, this.memo, this.time});
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.024),
      child: Bubble(
        alignment: memo.senderId != this.userId
            ? Alignment.centerLeft
            : Alignment.centerRight,
        radius: Radius.circular(SizeConfig.blockSizeHorizontal * 10),
        padding: BubbleEdges.all(SizeConfig.blockSizeHorizontal *
            SizeConfig.blockSizeVertical *
            1.5),
        nip: memo.senderId != this.userId
            ? BubbleNip.leftTop
            : BubbleNip.rightTop,
        color: memo.senderId != this.userId
            ? theme.primaryColor
            : theme.accentColor,
        nipWidth: SizeConfig.blockSizeHorizontal * 10,
        nipHeight: SizeConfig.blockSizeHorizontal * 10,
        nipRadius: SizeConfig.blockSizeHorizontal * 4,
        child: Column(
          children: [
            Text(
              memo.memo,
              textAlign: memo.senderId != this.userId
                  ? TextAlign.left
                  : TextAlign.right,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.blockSizeVertical * 4.2),
            ),
            Text(
              time,
              textAlign: memo.senderId != this.userId
                  ? TextAlign.left
                  : TextAlign.right,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.blockSizeVertical * 3),
            ),
          ],
        ),
      ),
    );
  }
}
