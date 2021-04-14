class OtherUser {
  String id, email, firstName, lastName, imageUrl;
  bool alreadyConnected;

  OtherUser.fromJson(Map<String, dynamic> data) {
    this.id = data["_id"];
    this.email = data["email"];
    this.firstName = data["first_name"];
    this.lastName = data["last_name"];
    this.imageUrl = data["image_url"];
    this.alreadyConnected = data["already_connected"];
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": this.id,
      "email": this.email,
      "first_name": this.firstName,
      "last_name": this.lastName,
      "image_url": this.imageUrl,
      "already_connected": this.alreadyConnected
    };
  }
}
