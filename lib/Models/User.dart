class User {
  String userId,
      email,
      firstName,
      lastName,
      phoneNo,
      accessToken,
      tokenType,
      profilePicUrl;

  int expiresIn;
  double createdAt;
  bool emailVerified;

  User.fromJson(Map<String, dynamic> data) {
    this.userId = data['_id'] ?? data['user_id'];
    this.email = data['email'];
    this.firstName = data['first_name'];
    this.lastName = data['last_name'];
    this.phoneNo = data['phone'];
    this.createdAt = data['created_at'];
    this.accessToken = data['access_token'];
    this.tokenType = data['token_type'];
    this.expiresIn = data['expires_in'];
    this.profilePicUrl = data['image_url'];
    this.emailVerified = data['email_verified'];
  }
  Map<String, dynamic> toJson() {
    return {
      "user_id": this.userId,
      "email": this.email,
      "first_name": this.firstName,
      "last_name": this.lastName,
      "phone": this.phoneNo,
      "created_at": this.createdAt,
      "access_token": this.accessToken,
      "token_type": this.tokenType,
      "expires_in": this.expiresIn,
      "image_url": this.profilePicUrl,
      "email_verified": this.emailVerified
    };
  }
}
