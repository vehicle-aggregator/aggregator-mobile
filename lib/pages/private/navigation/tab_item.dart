import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../../../routes.dart';

class TabItem{
  static const String DISCOUNT = '/discount';
  static const String HISTORY = '/history';
  static const String ITINERARY = '/itineraryList';
  static const String BALANCE = '/balance';
  static const String PROFILE = '/profile';
}

const tabItemsArray = ['/discount', '/history', '/itineraryList', '/balance', '/profile'];

class TabIcon{
  final Icon icon;
  final String title;
  final String route;
  final int index;

  const TabIcon({this.icon, this.title, this.route, this.index});
}

const Map<String, TabIcon> tabProperties = {
  TabItem.DISCOUNT : const TabIcon(title: 'Акции', icon: Icon(Icons.add_alert), route: Routes.discount, index: 0),
  TabItem.HISTORY : const TabIcon(title: 'История', icon: Icon(Icons.history), route: Routes.history, index: 1),
  TabItem.ITINERARY: const TabIcon(title: 'Маршруты', icon: Icon(Icons.map_outlined), route: Routes.itineraryList, index: 2),
  TabItem.BALANCE: const TabIcon(title: 'Баланс', icon: Icon(Icons.account_balance_wallet_outlined), route: Routes.balance, index: 3),
  TabItem.PROFILE : const TabIcon(title: 'Профиль', icon: Icon(Icons.account_circle_outlined), route: Routes.profile, index: 4),
};

List <PersistentBottomNavBarItem> navigationItems = [
  PersistentBottomNavBarItem(
    icon: Icon(CupertinoIcons.percent),
    title: ("Акции"),
    activeColorPrimary: Color(0xAA2C7BE5),
    inactiveColorPrimary: Color(0xAA7952B3),
  ),
  PersistentBottomNavBarItem(
    icon: Icon(Icons.history),
    title: ("История"),
    activeColorPrimary: Color(0xAA2C7BE5),
    inactiveColorPrimary: Color(0xAA7952B3),
  ),
  PersistentBottomNavBarItem(
    icon: Icon(CupertinoIcons.map),
    title: ("Маршруты"),
    activeColorPrimary: Color(0xAA2C7BE5),
    inactiveColorPrimary: Color(0xAA7952B3),
  ),
  PersistentBottomNavBarItem(
    icon: Icon(CupertinoIcons.money_rubl_circle),
    title: ("Баланс"),
    activeColorPrimary: Color(0xAA2C7BE5),
    inactiveColorPrimary: Color(0xAA7952B3),
  ),
  PersistentBottomNavBarItem(
    icon: Icon(CupertinoIcons.profile_circled),
    title: ("Профиль"),
    activeColorPrimary: Color(0xAA2C7BE5),
    inactiveColorPrimary: Color(0xAA7952B3),
  ),
];
