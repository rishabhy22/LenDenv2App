class Conversation {
  String id, title, creatorId, desc;
  List<dynamic> participants;
  double createdAt;

  Conversation.fromJson(Map<String, dynamic> data) {
    this.id = data["_id"];
    this.title = data["title"];
    this.creatorId = data["creator_id"];
    this.createdAt = data["created_at"];
    this.participants = data['participants'];
    this.desc = data['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": this.id,
      "title": this.title,
      "creator_id": this.creatorId,
      "created_at": this.createdAt,
      "participants": this.participants,
      "description": this.desc
    };
  }
}
