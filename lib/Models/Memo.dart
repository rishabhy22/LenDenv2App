class Memo {
  String memoType, type, convoId, senderId;
  dynamic memo;
  double sentTime;

  Memo.fromJson(Map<String, dynamic> data) {
    this.memoType = data["memo_type"];
    this.type = data['type'];
    this.convoId = data['conversation_id'];
    this.senderId = data["sender_id"];
    this.memo = data["message"] ?? data["amount"];
    this.sentTime = data["sent_time"];
  }

  Map<String, dynamic> toJson() {
    return {
      "memo_type": this.memoType,
      'type': this.type,
      'conversation_id': this.convoId,
      "sender_id": this.senderId,
      "memo": this.memo,
      "sent_time": this.sentTime
    };
  }
}
