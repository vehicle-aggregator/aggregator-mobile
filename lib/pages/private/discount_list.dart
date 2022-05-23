import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigation/bottom_navigation.dart';
import 'navigation/tab_item.dart';

class DiscountScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DiscountState();
}

class DiscountState extends State<DiscountScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Container(
            child: Text('Акции'),
          ),
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20),
          child: Text("Нет доступных акций...", style: TextStyle(color: Color(0xFF667689), fontSize: 18),)
      ),
    );
  }
}