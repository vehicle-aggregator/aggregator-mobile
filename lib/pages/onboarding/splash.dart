import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../routes.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //AuthModel auth;


  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => FocusScope.of(context).unfocus());

    Timer(Duration(milliseconds: 2000), () async {
      await Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    //auth = Provider.of<AuthModel>(context);

    return Material(
      color:Colors.white,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/logo_black.svg',
                height: 220,
                width: 220,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My", style: TextStyle(color: Color(0xAA7952B3), fontSize: 32, fontWeight: FontWeight.bold)),
                  Text("Transport", style: TextStyle(fontSize: 32, color: Color(0xAA667689), fontWeight: FontWeight.bold)),
                ],
              )
            ],
          )
      ),
    );
  }
}