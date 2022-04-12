
import 'package:aggregator_mobile/models/navigation_bar_item_value.dart';
import 'package:aggregator_mobile/pages/private/navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final String currentTab;
  final ValueChanged<String> onSelectTab;

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(TabItem.DISCOUNT),
        _buildItem(TabItem.HISTORY),
        _buildItem(TabItem.ITINERARY),
        _buildItem(TabItem.BALANCE),
        _buildItem(TabItem.PROFILE),
      ],
      onTap: (index) async =>  await Navigator.of(context).pushNamedAndRemoveUntil(tabItemsArray[index], (route) => false), //service.toggle(index),//onSelectTab(tabItemsArray[index]),
      currentIndex: tabProperties[currentTab].index,
      selectedItemColor: Colors.red // activeTabColor[currentTab],
    );
  }

  BottomNavigationBarItem _buildItem(String tabItem) {
    return BottomNavigationBarItem(
      icon: tabProperties[tabItem].icon,
      label: tabProperties[tabItem].title,
    );
  }

  // Future<void> onTap(int index, BuildContext context){
  //   var service = Provider.of<NavigationBarItemValue>(context);
  //   service.toggle()
  // }

  // Color _colorTabMatching(TabItem item) {
  //   return currentTab == item ? activeTabColor[item] : Colors.grey;
  // }
}