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
      body: Center( child: Text("Discount")),
    );
  }
}