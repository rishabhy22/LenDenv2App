import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:se_len_den/Models/Summary.dart';

class SummaryTile extends StatelessWidget {
  final CashFlow cashFlow;
  final TextStyle textStyle;
  SummaryTile({this.cashFlow, this.textStyle});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Text(
          cashFlow.from,
          textAlign: TextAlign.center,
          style: textStyle,
        )),
        Expanded(child: Icon(Icons.double_arrow_rounded)),
        Expanded(
            child: Text(cashFlow.to,
                textAlign: TextAlign.center, style: textStyle)),
        Expanded(
          child: Text(cashFlow.amount.toString(),
              textAlign: TextAlign.center, style: textStyle),
        )
      ],
    );
  }
}
