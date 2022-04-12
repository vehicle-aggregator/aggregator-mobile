import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigation/bottom_navigation.dart';
import 'navigation/tab_item.dart';

class BalanceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BalanceState();
}

class BalanceState extends State<BalanceScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( child: Text("Balance")),
    );
  }
}
