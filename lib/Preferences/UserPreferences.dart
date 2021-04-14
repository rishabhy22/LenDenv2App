import 'dart:convert';

import 'package:se_len_den/Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const key = "user";

  static void setUserPreference(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (user == null) {
      pref.remove(key);
    } else {
      pref.setString(key, jsonEncode(user));
    }
  }

  static Future<User> getUserPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String stringData = pref.getString(key) ?? null;

    if (stringData != null) {
      var data = jsonDecode(stringData);
      var user = User.fromJson(data);

      return user;
    } else
      return null;
  }
}
