
import 'package:aggregator_mobile/pages/onboarding/login.dart';
import 'package:aggregator_mobile/pages/onboarding/splash.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String noInternetConnection = '/noInternetConnection';
  static const String login = '/login';
  static const String home = '/home';
  static const String pinCode = '/pinCode';


  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
  };

}
