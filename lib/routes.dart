
import 'package:aggregator_mobile/pages/onboarding/login.dart';
import 'package:aggregator_mobile/pages/onboarding/pincode.dart';
import 'package:aggregator_mobile/pages/onboarding/splash.dart';
import 'package:aggregator_mobile/pages/private/balance.dart';
import 'package:aggregator_mobile/pages/private/discount_list.dart';
import 'package:aggregator_mobile/pages/private/history_list.dart';
import 'package:aggregator_mobile/pages/private/home.dart';
import 'package:aggregator_mobile/pages/private/itinerary_list.dart';
import 'package:aggregator_mobile/pages/private/profile.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String noInternetConnection = '/noInternetConnection';
  static const String login = '/login';
  static const String home = '/home';
  static const String pinCode = '/pinCode';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String discount = '/discount';
  static const String balance = '/balance';
  static const String itineraryList = '/itineraryList';


  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    pinCode: (BuildContext context) => PinCodeScreen(),
    home: (BuildContext context) => Home(),
    profile: (BuildContext context) => ProfileScreen(),
    history: (BuildContext context) => HistoryListScreen(),
    discount: (BuildContext context) => DiscountScreen(),
    itineraryList: (BuildContext context) => ItineraryListScreen(),
    balance: (BuildContext context) => BalanceScreen(),
  };

}
