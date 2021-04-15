class Memo {
  String id, memoType, convoId, senderId;
  dynamic memo, type;
  double sentTime;

  Memo.fromJson(Map<String, dynamic> data) {
    this.id = data["_id"];
    this.memoType = data["memo_type"];
    this.type = data['type'];
    this.convoId = data['conversation_id'];
    this.senderId = data["sender_id"];
    this.memo = data["message"] ?? data["amount"];
    this.sentTime = data["sent_time"];
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": this.id,
      "memo_type": this.memoType,
      'type': this.type,
      'conversation_id': this.convoId,
      "sender_id": this.senderId,
      "memo": this.memo,
      "sent_time": this.sentTime
    };
  }
}
