import 'package:flutter/material.dart';
import 'package:se_len_den/BLoC/RoutesBloc.dart';
import 'package:se_len_den/Models/Conversation.dart';
import 'package:se_len_den/utils/deviceSizing.dart';

class CustomSliverList extends StatelessWidget {
  final List<Conversation> conversations;
  final String accessToken;
  final String userId;
  CustomSliverList({this.accessToken, this.userId, this.conversations});
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return conversations.length != 0
        ? SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return index % 2 != 0
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.038,
                          right: SizeConfig.screenWidth * 0.038),
                      child: GestureDetector(
                        onTap: () {
                          RoutesBloc().setRoute(RouteWithData(
                              route: Routes.MEMO,
                              data: [
                                this.accessToken,
                                this.userId,
                                this.conversations.elementAt(index ~/ 2),
                                null
                              ]));
                        },
                        child: Container(
                          height: SizeConfig.screenHeight * 0.1,
                          child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              subtitle: Text(
                                "${conversations.elementAt(index ~/ 2).lastMemo["sender_id"] ?? ''} : ${conversations.elementAt(index ~/ 2).lastMemo["memo"] ?? ''}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                              title: Text(
                                conversations.elementAt(index ~/ 2).title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.blockSizeVertical * 5,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    )
                  : Divider(
                      thickness: SizeConfig.screenHeight * 0.001,
                      color: theme.primaryColor,
                      indent: SizeConfig.screenWidth * 0.038,
                      endIndent: SizeConfig.screenWidth * 0.038,
                    );
            }, childCount: 2 * conversations.length + 1),
          )
        : SliverFillRemaining(
            child: Center(
                child: Image.asset(
            "assets/images/empty.png",
            width: SizeConfig.screenWidth * 0.3,
            height: SizeConfig.screenHeight * 0.2,
            color: Colors.white,
          )));
  }
}
