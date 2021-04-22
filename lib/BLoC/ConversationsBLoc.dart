import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:se_len_den/Models/Conversation.dart';
import 'package:se_len_den/Models/RequestStatus.dart';
import 'package:se_len_den/Models/Summary.dart';

class ConvoBloc {
  static final ConvoBloc _convoBloc = ConvoBloc._private();
  ConvoBloc._private();
  factory ConvoBloc() => _convoBloc;

  String endpoint = "http://10.0.2.2:5002";
  String convoRoute = "/convo";
  String summarizeRoute = "/summary";

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
        convos.sort((a, b) {
          if (a.lastCommit > b.lastCommit) return -1;
          return 1;
        });
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
        return Status("success", null, 200,
            data: Conversation.fromJson(res["data"]));
      } else {
        return Status(res["status"], res["error"], response.statusCode);
      }
    } catch (e) {
      return Status("failure", e.toString(), 0);
    }
  }

  Future<SummaryResponse> getSummary(String accessToken, String convoId) async {
    try {
      Map<String, String> authHeader = {
        "Content-Type": "application/json",
        "Authorization": "Token $accessToken"
      };

      http.Response response = await http.get(
          Uri.parse(endpoint + summarizeRoute + "/$convoId"),
          headers: authHeader);

      print(response.body);

      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SummaryResponse.fromJson(res);
      } else {
        return SummaryResponse.fromJson(res);
      }
    } catch (e) {
      print(e);
      return SummaryResponse(
          status: "failure", error: e.toString(), due: null, cashFlow: null);
    }
  }
}
