import 'package:se_len_den/Models/User.dart';

class AuthResponse {
  String error, status;
  User user;
  int statusCode;

  AuthResponse({this.error, this.status, this.statusCode, this.user});

  AuthResponse.fromJson(Map<String, dynamic> response, int statusCode) {
    this.error = response['error'];
    this.status = response['status'];
    this.statusCode = statusCode;
    if (response["data"] != null)
      this.user = User.fromJson(response["data"]);
    else
      this.user = null;
  }
  Map<String, dynamic> toJson() {
    return {
      "error": this.error,
      "status": this.status,
      "user": this.user,
      "statusCode": this.statusCode
    };
  }
}
