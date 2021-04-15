import 'dart:async';

import 'package:rxdart/rxdart.dart';

enum Routes {
  AUTH,
  DASHBOARD,
  CONNECTIONS,
  CONVERSATIONS,
  CONNECTIONPROFILE,
  ADDCONVERSATION,
  MEMO,
  CONVERSATIONPROFILE
}

class RoutesBloc {
  static final RoutesBloc _routesBloc = RoutesBloc._private();
  RoutesBloc._private();
  factory RoutesBloc() => _routesBloc;

  static StreamController<RouteWithData> routeController =
      BehaviorSubject<RouteWithData>();

  Stream<RouteWithData> get getRoute => routeController.stream;

  Function(RouteWithData) get setRoute => routeController.sink.add;

  void init() {
    if (routeController.isClosed) {
      routeController = BehaviorSubject<RouteWithData>();
    }
  }

  void dispose() {
    if (!routeController.isClosed) {
      routeController.close();
    }
  }
}

class RouteWithData {
  Routes route;
  dynamic data;

  RouteWithData({this.route, this.data});
}
