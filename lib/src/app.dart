import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fun_to_do/src/pages/loading_page.dart';
import 'package:fun_to_do/src/pages/offline_page.dart';
import 'package:fun_to_do/src/pages/signin_page.dart';

import 'package:fun_to_do/src/service/theme_mode_sp.dart';
import 'package:fun_to_do/src/scoped-model/main_model.dart';
import 'package:fun_to_do/src/screens/main_screen.dart';
import 'package:fun_to_do/src/service/user_info_sp.dart';
import 'package:scoped_model/scoped_model.dart';

class FunToDo extends StatefulWidget {
  // final SharedPref sharedPref = SharedPref();

  @override
  _FunToDoState createState() => _FunToDoState();
}

class _FunToDoState extends State<FunToDo> {
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  String isOnline;

  bool themeMode;
  String token = 'timeout';
  String user_id;
  getThemeMode() async {
    bool themeMode = await ThemeModeSP.getBoolThemeMode();
    return themeMode;
  }

  getTokenSP() async {
    String token = await UserInfoSP.getUserToken();
    return token;
  }

  getUser_idSP() async {
    String user_id = await UserInfoSP.getUserUser_id();
    return user_id;
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  final MainModel mainModel = MainModel();
  @override
  void initState() {
    super.initState();
    getThemeMode().then((response) {
      setState(() {
        themeMode = response;
      });
    });
    getTokenSP().then((response) {
      setState(() {
        token = response;
      });
    });
    getUser_idSP().then((response) {
      setState(() {
        user_id = response;
      });
    });

    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          isOnline = 'online';
        });
      } else {
        setState(() {
          isOnline = 'offline';
        });
      }
      print('isOnline: ${isOnline}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return isOnline == 'offline'
        ? OfflinePage()
        : ScopedModel<MainModel>(
            model: mainModel,
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Fun ToDo',
                theme: ThemeData(
                    primaryColor: Colors.amberAccent,
                    bottomAppBarColor: Colors.grey[200],
                    primaryColorLight: Colors.black,
                    cardColor: Colors.white,
                    shadowColor: Colors.black),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  /* dark theme settings */
                  primaryColor: Colors.amberAccent,
                  bottomAppBarColor: Colors.black,
                  cardColor: Colors.grey,
                  shadowColor: Colors.grey,
                ),
                themeMode: themeMode == true ? ThemeMode.dark : ThemeMode.light,
                home: token == 'timeout'
                    ? LoadingPage()
                    : token == null
                        ? SignInPage()
                        : MainScreen(
                            model: mainModel, token: token, user_id: user_id)),
          );
  }
}
