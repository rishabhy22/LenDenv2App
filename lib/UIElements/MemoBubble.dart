import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:se_len_den/Models/Memo.dart';
import 'package:se_len_den/utils/deviceSizing.dart';

class CustomChatBubble extends StatelessWidget {
  final Memo memo;
  final String userId, time;
  Color color;

  CustomChatBubble({this.userId, this.memo, this.time});
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (memo.memoType == "chat") {
      color =
          memo.senderId != this.userId ? theme.primaryColor : theme.accentColor;
    } else {
      if (memo.senderId != this.userId) {
        color = memo.type == 1 ? Colors.red : Colors.green;
      } else {
        color = memo.type != 1 ? Colors.red : Colors.green;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.024),
      child: Bubble(
        elevation: SizeConfig.screenHeight * 0.012,
        borderWidth:
            memo.memoType == "transaction" ? SizeConfig.blockSizeHorizontal : 0,
        borderColor: Colors.black,
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
        color: color,
        nipWidth: SizeConfig.blockSizeHorizontal * 10,
        nipHeight: SizeConfig.blockSizeHorizontal * 10,
        nipRadius: SizeConfig.blockSizeHorizontal * 4,
        child: Column(
          crossAxisAlignment: memo.senderId != this.userId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              memo.senderId,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: SizeConfig.blockSizeVertical * 3,
                  fontWeight: FontWeight.bold),
            ),
            memo.memoType == "chat"
                ? Text(
                    memo.memo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.blockSizeVertical * 4.6),
                  )
                : Container(
                    width: SizeConfig.screenWidth * 0.5,
                    child: Text(
                      memo.memo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.blockSizeVertical * 5,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 3,
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
