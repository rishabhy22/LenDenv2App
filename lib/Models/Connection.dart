import 'package:se_len_den/Models/OtherUser.dart';

class Connection {
  String id, userId, contactId, aliasNameUser, aliasNameContact;
  OtherUser otherUser;
  bool isPending;
  double createdAt;

  Connection.fromJson(Map<String, dynamic> data) {
    this.id = data["_id"];
    this.userId = data["user_id"];
    this.contactId = data["contact_id"];
    this.aliasNameUser = data["alias_name_user"];
    this.aliasNameContact = data["alias_name_contact"];
    this.isPending = data["is_pending"];
    this.createdAt = data["created_at"];
    this.otherUser = OtherUser.fromJson(data['other_user']);
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": this.id,
      "user_id": this.userId,
      "contact_id": this.contactId,
      "alias_name_user": this.aliasNameUser,
      "alias_name_contact": this.aliasNameContact,
      "is_pending": this.isPending,
      "created_at": this.createdAt,
      "other_user": this.otherUser
    };
  }
}
