import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigation/bottom_navigation.dart';
import 'navigation/tab_item.dart';

class HistoryListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HistoryListState();
}

class HistoryListState extends State<HistoryListScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( child: Text("История")),
    );
  }
}