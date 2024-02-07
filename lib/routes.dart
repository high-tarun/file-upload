import 'package:flutter/material.dart';
import 'package:testapp_1/view/authentication/login_page.dart';
import 'package:testapp_1/view/authentication/signup_page.dart';
import 'package:testapp_1/view/home/home_page.dart';

class RoutesHandler {
  static Route onGenerateRoute(RouteSettings settings) {
    late Widget widget;
    String? screenName = settings.name;
    var args = settings.arguments;
    switch (screenName) {
      case LoginPage.route:
        widget = const LoginPage();
        break;
      case SignupScreen.route:
        widget = const SignupScreen();
        break;
      case HomePageScreen.route:
        widget = const HomePageScreen();
        break;
      default:
        widget = const Scaffold();
    }
    return MaterialPageRoute(builder: (context) => widget);
  }
}
