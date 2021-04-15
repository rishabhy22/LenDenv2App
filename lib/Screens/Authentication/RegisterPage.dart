import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:se_len_den/BLoC/AuthenticationBloc.dart';
import 'package:se_len_den/Models/RequestStatus.dart';
import 'package:se_len_den/UIElements/ClippedContainer.dart';
import 'package:se_len_den/utils/support.dart';
import 'package:flutter/material.dart';
import 'package:se_len_den/utils/deviceSizing.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({this.toggle});

  final Function toggle;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with CommonPageDesign {
  String username, passwd, confirmPasswd, firstName, lastName, email, phoneNo;
  File file;
  bool validate = false, isLoading = false;
  String passwdValidator(String value1, String value2) {
    if (value1 == null) return 'Password cannot be null';
    if (value1 != value2) {
      return 'Passwords do not match';
    }
    if (value1.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value1.length < 9) {
      return 'Password must be greater than 9 characters';
    }

    return null;
  }

  String emailValidator(String value) {
    if (value == null) return 'Email cannot be null';
    if (value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!value.contains('@')) {
      return 'Invalid Email';
    }
    return null;
  }

  String commonValidator(String value, String valueName) {
    if (value == null) return '$valueName cannot be null';
    if (value.isEmpty) return '$valueName cannot be empty';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Positioned.fill(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.127,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.153,
                        ),
                        GestureDetector(
                          onTap: () {
                            this.widget.toggle(false);
                          },
                          child: Container(
                            width: SizeConfig.screenWidth * 0.258,
                            height: SizeConfig.screenHeight * 0.043,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'SIGN IN',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headline1,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.184,
                        ),
                        Container(
                          width: SizeConfig.screenWidth * 0.258,
                          height: SizeConfig.screenHeight * 0.043,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xFFDB7093),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'SIGN UP',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headline1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.075,
                    ),
                    ClippedContainer(Container(
                      width: SizeConfig.screenWidth * 0.885,
                      height: SizeConfig.screenHeight * 0.58,
                      decoration: BoxDecoration(
                        color: theme.accentColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.088,
                          ),
                          LimitedBox(
                            maxHeight: SizeConfig.screenHeight * 0.4,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.screenWidth * 0.094,
                                        right: SizeConfig.screenWidth * 0.094),
                                    child: TextField(
                                      style: theme.textTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintText: "First Name",
                                          hintStyle: TextStyle(
                                            fontSize: 15.0,
                                            height: 0,
                                            color: Colors.white,
                                          ),
                                          errorText: validate
                                              ? commonValidator(
                                                  firstName, "First Name")
                                              : null,
                                          errorStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      onChanged: (value) {
                                        setState(() {
                                          firstName = value;
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
                                    child: TextFormField(
                                      style: theme.textTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintText: "Last Name",
                                          hintStyle: TextStyle(
                                            fontSize: 15.0,
                                            height: 0,
                                            color: Colors.white,
                                          ),
                                          errorText: validate
                                              ? commonValidator(
                                                  lastName, "Last Name")
                                              : null,
                                          errorStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      onChanged: (value) {
                                        lastName = value;
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
                                    child: TextFormField(
                                      style: theme.textTheme.bodyText1,
                                      textAlign: TextAlign.start,
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
                                              ? commonValidator(
                                                  username, "Username")
                                              : null,
                                          errorStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      onChanged: (value) {
                                        username = value;
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
                                    child: TextFormField(
                                      style: theme.textTheme.bodyText1,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                            fontSize: 15.0,
                                            height: 0,
                                            color: Colors.white,
                                          ),
                                          errorText: validate
                                              ? emailValidator(email)
                                              : null,
                                          errorStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      onChanged: (value) {
                                        email = value;
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
                                    child: TextFormField(
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
                                              ? passwdValidator(
                                                  passwd, confirmPasswd)
                                              : null,
                                          errorStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      onChanged: (value) {
                                        passwd = value;
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
                                    child: TextFormField(
                                      style: theme.textTheme.bodyText1,
                                      obscureText: true,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintText: "Confirm Password",
                                          hintStyle: TextStyle(
                                            fontSize: 15.0,
                                            height: 0,
                                            color: Colors.white,
                                          ),
                                          errorText: validate
                                              ? passwdValidator(
                                                  passwd, confirmPasswd)
                                              : null,
                                          errorStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      onChanged: (value) {
                                        setState(() {
                                          confirmPasswd = value;
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
                              if (passwdValidator(passwd, confirmPasswd) ==
                                      null &&
                                  emailValidator(email) == null &&
                                  commonValidator(username, "") == null &&
                                  commonValidator(firstName, "") == null &&
                                  commonValidator(lastName, "") == null) {
                                setState(() {
                                  validate = false;
                                  isLoading = true;
                                });
                                Status status = await AuthBloc().signUp(
                                    firstName,
                                    lastName,
                                    username,
                                    email,
                                    passwd,
                                    phoneNo,
                                    file);
                                if (status.status != "success") {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 10),
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
                ),
              ),
              Positioned.directional(
                textDirection: TextDirection.ltr,
                top: SizeConfig.screenHeight * 0.18,
                width: SizeConfig.screenWidth * 0.32,
                start: SizeConfig.screenWidth * 0.34,
                height: SizeConfig.screenHeight * 0.15,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.fromBorderSide(BorderSide(
                          color: theme.accentColor,
                          width: SizeConfig.screenWidth * 0.022)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    child: GestureDetector(
                      onTap: () async {
                        FilePickerResult fileRes = await FilePicker.platform
                            .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                              'jpg',
                              'jpeg',
                              'png',
                            ]);
                        if (fileRes != null) {
                          if (fileRes.files.single.size < 1 * 1024 * 1024) {
                            setState(() {
                              file = File(fileRes.files.first.path);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "File size should be less than 1MB",
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
                        }
                      },
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: file != null
                            ? Image.file(file)
                            : Image.asset(
                                'assets/images/avatar.png',
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
