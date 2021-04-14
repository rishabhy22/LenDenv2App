import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:se_len_den/Models/Connection.dart';
import 'package:se_len_den/Models/OtherUser.dart';
import 'package:se_len_den/Models/RequestStatus.dart';

class ConnectionsBloc {
  static final ConnectionsBloc _connectionsBloc = ConnectionsBloc._private();
  ConnectionsBloc._private();
  factory ConnectionsBloc() => _connectionsBloc;

  String endpoint = "http://10.0.2.2:5002";
  String connRoute = "/connections";
  String fetchUsersRoute = "/fetch/users/";

  Future<List<Connection>> getConnections(String accessToken) async {
    try {
      Map<String, String> authHeader = {
        "Content-Type": "application/json",
        "Authorization": "Token $accessToken"
      };
      http.Response response =
          await http.get(Uri.parse(endpoint + connRoute), headers: authHeader);

      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<Connection> connections = List<Connection>.empty(growable: true);

        for (var c in res["data"]) {
          connections.add(Connection.fromJson(c));
        }
        return connections;
      } else {
        return List<Connection>.empty();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Status> setConnection(String accessToken, String contactId,
      {String contactsName}) async {
    try {
      Map<String, String> authHeader = {
        "Content-Type": "application/json",
        "Authorization": "Token $accessToken"
      };

      Map<String, dynamic> body = {
        "contact_id": contactId,
        "alias_name_contact": contactsName
      };
      http.Response response = await http.post(Uri.parse(endpoint + connRoute),
          headers: authHeader, body: jsonEncode(body));
      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Status("success", null, 200);
      } else {
        return Status(res["status"], res["error"], response.statusCode);
      }
    } catch (e) {
      print(e);
      return Status("failure", e.toString(), 0);
    }
  }

  Future<List<OtherUser>> fetchUsers(String accessToken, String value) async {
    try {
      Map<String, String> authHeader = {
        "Content-Type": "application/json",
        "Authorization": "Token $accessToken"
      };

      if (value != null && value != "") {
        http.Response response = await http.get(
            Uri.parse(endpoint + fetchUsersRoute + value),
            headers: authHeader);
        var res = jsonDecode(response.body);
        print(response.body);
        if (response.statusCode == 200) {
          List<OtherUser> otherUsers = List<OtherUser>.empty(growable: true);

          for (var c in res["data"]) {
            otherUsers.add(OtherUser.fromJson(c));
          }
          return otherUsers;
        } else {
          return List<OtherUser>.empty();
        }
      }
    } catch (e) {}
  }
}
