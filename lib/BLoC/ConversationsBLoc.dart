import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:se_len_den/Models/Conversation.dart';
import 'package:se_len_den/Models/RequestStatus.dart';

class ConvoBloc {
  static final ConvoBloc _convoBloc = ConvoBloc._private();
  ConvoBloc._private();
  factory ConvoBloc() => _convoBloc;

  String endpoint = "http://10.0.2.2:5002";
  String convoRoute = "/convo";

  Future<List<Conversation>> getConvo(String accessToken) async {
    try {
      Map<String, String> authHeader = {
        "Content-Type": "application/json",
        "Authorization": "Token $accessToken"
      };
      http.Response response =
          await http.get(Uri.parse(endpoint + convoRoute), headers: authHeader);

      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<Conversation> convos = List<Conversation>.empty(growable: true);
        for (var c in res["data"]) convos.add(Conversation.fromJson(c));
        return convos;
      } else {
        return List<Conversation>.empty();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Status> setConvo(String accessToken, String title,
      List<String> participants, String description) async {
    try {
      Map<String, String> authHeader = {
        "Content-Type": "application/json",
        "Authorization": "Token $accessToken"
      };

      Map<String, dynamic> body = {
        "title": title,
        "participants": participants,
        "description": description
      };
      http.Response response = await http.post(Uri.parse(endpoint + convoRoute),
          headers: authHeader, body: jsonEncode(body));
      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Status("success", null, 200);
      } else {
        return Status(res["status"], res["error"], response.statusCode);
      }
    } catch (e) {
      return Status("failure", e.toString(), 0);
    }
  }
}
