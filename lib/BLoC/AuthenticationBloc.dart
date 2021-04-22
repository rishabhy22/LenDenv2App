import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:rxdart/rxdart.dart';

import 'package:se_len_den/Models/AuthResponse.dart';
import 'package:se_len_den/Models/RequestStatus.dart';
import 'package:http/http.dart' as http;
import 'package:se_len_den/Models/User.dart';
import 'package:se_len_den/Preferences/UserPreferences.dart';

class AuthBloc {
  static final AuthBloc _authBloc = AuthBloc._internal();
  AuthBloc._internal() {
    initAuth();
  }
  factory AuthBloc() => _authBloc;

  String endpoint = "http://10.0.2.2:5001";
  String signinRoute = "/signin";
  String signupRoute = "/signup";
  String verifyTokenRoute = "/verify/token";
  String verifyEmail = "/verify/email";

  Map<String, String> headers = {"Content-Type": "application/json"};

  static StreamController<AuthResponse> authController =
      BehaviorSubject<AuthResponse>();

  Function(AuthResponse) get setAuth => authController.sink.add;

  Stream<AuthResponse> get getAuth => authController.stream;

  Future<Status> signIn(String username, String password) async {
    Map<String, String> body = {"user_id": username, "password": password};
    try {
      http.Response response = await http.post(
          Uri.parse(endpoint + signinRoute),
          headers: headers,
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var reqbody = jsonDecode(response.body);
        setAuth(AuthResponse.fromJson(reqbody, 200));
        return Status(reqbody["status"], reqbody["error"], response.statusCode);
      } else {
        var reqbody = jsonDecode(response.body);
        setAuth(AuthResponse.fromJson(reqbody, response.statusCode));
        return Status(reqbody["status"], reqbody["error"], response.statusCode);
      }
    } catch (e) {
      return Status("failure", "$e", 0);
    }
  }

  Future<Status> signUp(String firstName, String lastName, String username,
      String email, String password, String phoneNo, File file) async {
    Map<String, String> body = {
      "user_id": username,
      "password": password,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "phone": phoneNo
    };

    try {
      http.MultipartRequest request =
          http.MultipartRequest("POST", Uri.parse(endpoint + signupRoute));

      request.files.add(http.MultipartFile.fromBytes(
          "image_data", file != null ? await file.readAsBytes() : Uint8List(0),
          filename: file != null ? file.path.split("/").last : "",
          contentType: MediaType("image",
              file != null ? file.path.split("/").last.split(".").last : "")));

      request.files.add(http.MultipartFile.fromBytes(
          "json",
          utf8.encode(
            jsonEncode(body),
          ),
          contentType: MediaType("application", "json")));
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        "Content-Disposition": "form-data"
      });
      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var reqbody = jsonDecode(response.body);
        setAuth(AuthResponse.fromJson(reqbody, 200));
        return Status(reqbody["status"], reqbody["error"], response.statusCode);
      } else {
        var reqbody = jsonDecode(response.body);
        setAuth(AuthResponse.fromJson(reqbody, response.statusCode));
        return Status(reqbody["status"], reqbody["error"], response.statusCode);
      }
    } catch (e) {
      setAuth(AuthResponse(
          error: e.toString(), status: "failure", statusCode: 0, user: null));
      return Status("failure", "${e.toString()}", 0);
    }
  }

  Future<void> signOut() async {
    UserPreferences.setUserPreference(null);
    setAuth(AuthResponse(
        error: null, status: "success", statusCode: 200, user: null));
  }

  Future<Status> sendVerificationMail(String accessToken) async {
    Map<String, String> authHeader = {
      "Content-Type": "application/json",
      "Authorization": "Token $accessToken"
    };
    try {
      http.Response response = await http.get(Uri.parse(endpoint + verifyEmail),
          headers: authHeader);

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

  Future<void> verifyToken() async {
    try {
      var user = await UserPreferences.getUserPreference();
      if (user != null) {
        Map<String, String> authHeader = {
          "Content-Type": "application/json",
          "Authorization": "Token ${user.accessToken}"
        };

        http.Response response = await http
            .get(Uri.parse(endpoint + verifyTokenRoute), headers: authHeader);

        var reqBody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          setAuth(AuthResponse(
              error: reqBody["error"],
              status: reqBody["status"],
              statusCode: 200,
              user: User.fromJson(reqBody["data"])));
        } else {
          setAuth(AuthResponse(
              error: reqBody["error"],
              status: reqBody["status"],
              statusCode: response.statusCode,
              user: null));
        }
      }
    } catch (e) {
      setAuth(AuthResponse(
          error: e.toString(), status: "failure", statusCode: 0, user: null));
    }
  }

  void initAuth() {
    if (authController.isClosed)
      authController = BehaviorSubject<AuthResponse>();
  }

  void disposeAuth() {
    if (!authController.isClosed) authController.close();
  }
}
