import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/pages/private/balance.dart';
import 'package:aggregator_mobile/pages/private/discount_list.dart';
import 'package:aggregator_mobile/pages/private/history_list.dart';
import 'package:aggregator_mobile/pages/private/itinerary_list.dart';
import 'package:aggregator_mobile/pages/private/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes.dart';
import 'navigation/bottom_navigation.dart';
import 'navigation/tab_item.dart';

class Home extends StatefulWidget{

  @override
  HomeState createState() => HomeState();

}



class HomeState extends State<Home>{
  PersistentTabController _controller;

  @override
  initState(){
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      DiscountScreen(),
      HistoryListScreen(),
      ItineraryListScreen(),
      BalanceScreen(),
      ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: navigationItems,
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
















  // var _currentTab = TabItem.ITINERARY;
  // final _navigatorKeys = {
  //   TabItem.DISCOUNT: GlobalKey<NavigatorState>(),
  //   TabItem.HISTORY: GlobalKey<NavigatorState>(),
  //   TabItem.ITINERARY: GlobalKey<NavigatorState>(),
  //   TabItem.BALANCE: GlobalKey<NavigatorState>(),
  //   TabItem.PROFILE: GlobalKey<NavigatorState>(),
  // };
  //
  // void _selectTab(String tabItem) {
  //
  //   setState(() {
  //     _currentTab = tabItem;
  //   });
  //
  //   // if (tabItem == _currentTab) {
  //   //   _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
  //   // } else {
  //   //   setState(() => _currentTab = tabItem);
  //   // }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(child: Text('HOME')),
  //       // body: Stack(children: <Widget>[
  //       //   _buildOffstageNavigator(TabItem.red),
  //       //   _buildOffstageNavigator(TabItem.green),
  //       //   _buildOffstageNavigator(TabItem.blue),
  //       //   _buildOffstageNavigator(TabItem.yellow),
  //       //   _buildOffstageNavigator(TabItem.purple),
  //       // ]),
  //       bottomNavigationBar: BottomNavigation(
  //         currentTab: TabItem.ITINERARY,
  //       ),
  //     )
  //   //)
  //   ;
  // }

  // Widget _buildOffstageNavigator(TabItem tabItem) {
  //   return
  //     // Offstage(
  //     // offstage: _currentTab != tabItem,
  //     // child:
  //     TabNavigator(
  //       navigatorKey: _navigatorKeys[tabItem],
  //       tabItem: tabItem,
  //     )
  //   //)
  //   ;
  // }



  // AuthModel auth;
  // String pin;
  //
  // @override
  // Widget build(BuildContext context) {
  //   auth = Provider.of<AuthModel>(context);
  //
  //
  //   return Scaffold(
  //     // bottomNavigationBar: BottomNavigationBar(
  //     //   items:[
  //     //     BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket_rounded, color: Color(0xAA7952B3)), label: 'Билеты'),
  //     //     BottomNavigationBarItem(icon: Icon(Icons.monetization_on_outlined, color: Color(0xAA7952B3)), label: 'Баланс'),
  //     //     BottomNavigationBarItem(icon: Icon(Icons.map_outlined, color: Color(0xAA7952B3)), label: 'Маршруты'),
  //     //     BottomNavigationBarItem(icon: Icon(Icons.add_alert, color: Color(0xAA7952B3)), label: 'zxc'),
  //     //     BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, color: Color(0xAA7952B3)), label: 'asd'),
  //     //   ]
  //     // ),
  //     bottomNavigationBar: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children:[
  //           Container(child: Icon(Icons.airplane_ticket_rounded, color: Color(0xAA7952B3)),),
  //           Container(child: Icon(Icons.monetization_on_outlined, color: Color(0xAA7952B3)), ),
  //           Container(child: Icon(Icons.map_outlined, color: Color(0xAA7952B3)), ),
  //           Container(child: Icon(Icons.add_alert, color: Color(0xAA7952B3)), ),
  //           Container(child: Icon(Icons.account_circle_outlined, color: Color(0xAA7952B3)),),
  //           Container(child: Icon(Icons.account_circle_outlined, color: Color(0xAA7952B3)),),
  //         ]
  //     ),
  //     body: Center(
  //         child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               Text("Добро пожаловать в приложение\n Оно еще не готово"),
  //               Text("${auth.user.email} --- ${auth.user.surname} --- ${ auth.user.lastname} --- "),
  //               TextButton(
  //                   onPressed: () async{
  //                     var i = await SharedPreferences.getInstance();
  //                     var pinCode = i.getString("PIN_CODE");
  //                     setState(() {
  //                       pin = pinCode;
  //                     });
  //                   },
  //                   style: TextButton.styleFrom(
  //                     backgroundColor: Colors.red
  //                   ),
  //                   child: Text("Показать пинкод", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
  //               ),
  //               Text(pin ?? ""),
  //               TextButton(
  //                   onPressed: () async {
  //                     auth.logout();
  //                     await Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (route) => false);
  //                   },
  //                   child: Text("Выйти"))
  //             ]
  //         )
  //
  //     ),
  //   );
  // }
}