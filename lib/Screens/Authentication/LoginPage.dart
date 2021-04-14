import 'package:se_len_den/BLoC/AuthenticationBloc.dart';
import 'package:se_len_den/Models/RequestStatus.dart';
import 'package:se_len_den/UIElements/ClippedContainer.dart';
import 'package:se_len_den/utils/support.dart';
import 'package:flutter/material.dart';
import 'package:se_len_den/utils/deviceSizing.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.toggle});

  final Function toggle;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with CommonPageDesign {
  String username;

  String passwd;
  bool isLoading = false;
  bool validate = false;
  String passwdValidator(String value) {
    if (value == null) return 'Password cannot be null';
    if (value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 9) {
      return 'Password must be greater than 9 characters';
    }
    return null;
  }

  String usernameValidator(String value) {
    if (value == null) return 'Username cannot be null';
    if (value.isEmpty) return 'Username cannot be empty';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      child: LimitedBox(
        maxHeight: SizeConfig.screenHeight,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Container(
                decoration: bgDecoration(theme),
              )),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.127,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.153,
                      ),
                      Container(
                        width: SizeConfig.screenWidth * 0.258,
                        height: SizeConfig.screenHeight * 0.043,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFFDB7093),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'SIGN IN',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headline1,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.184,
                      ),
                      GestureDetector(
                        onTap: () {
                          this.widget.toggle(true);
                        },
                        child: Container(
                          width: SizeConfig.screenWidth * 0.258,
                          height: SizeConfig.screenHeight * 0.043,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'SIGN UP',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headline1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.075,
                  ),
                  ClippedContainer(Container(
                    width: SizeConfig.screenWidth * 0.885,
                    height: SizeConfig.screenHeight * 0.42,
                    decoration: BoxDecoration(
                      color: theme.accentColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.0936,
                        ),
                        LimitedBox(
                          maxHeight: SizeConfig.screenHeight * 0.29,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * 0.094,
                                      right: SizeConfig.screenWidth * 0.094),
                                  child: TextField(
                                    style: theme.textTheme.bodyText1,
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: "Username",
                                        hintStyle: TextStyle(
                                          fontSize: 15.0,
                                          height: 0,
                                          color: Colors.white,
                                        ),
                                        errorText: validate
                                            ? usernameValidator(username)
                                            : null,
                                        errorStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    onChanged: (value) {
                                      setState(() {
                                        username = value;
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * 0.06,
                                      right: SizeConfig.screenWidth * 0.06,
                                      bottom: SizeConfig.screenHeight * 0.01),
                                  child: Divider(
                                    color: Colors.black,
                                    height: 0,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * 0.094,
                                      right: SizeConfig.screenWidth * 0.094),
                                  child: TextField(
                                    style: theme.textTheme.bodyText1,
                                    obscureText: true,
                                    textAlign: TextAlign.start,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                          fontSize: 15.0,
                                          height: 0,
                                          color: Colors.white,
                                        ),
                                        errorText: validate
                                            ? passwdValidator(passwd)
                                            : null,
                                        errorStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    onChanged: (value) {
                                      setState(() {
                                        passwd = value;
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * 0.06,
                                      right: SizeConfig.screenWidth * 0.06),
                                  child: Divider(
                                    color: Colors.black,
                                    height: 0,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (passwdValidator(passwd) == null &&
                                usernameValidator(username) == null) {
                              setState(() {
                                validate = false;
                                isLoading = true;
                              });
                              Status status =
                                  await AuthBloc().signIn(username, passwd);
                              if (status.status != "success") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    status.error,
                                    style: theme.textTheme.subtitle2,
                                  ),
                                  backgroundColor: theme.primaryColor,
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ));
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                validate = true;
                              });
                            }
                          },
                          child: ClippedButton(
                              child: Container(
                                  width: SizeConfig.screenWidth * 0.885,
                                  height: SizeConfig.screenHeight * 0.088,
                                  alignment: Alignment.center,
                                  color: theme.iconTheme.color,
                                  child: !isLoading
                                      ? Text(
                                          "CONTINUE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      : CircularProgressIndicator())),
                        ),
                      ],
                    ),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
