import 'dart:async';
import 'dart:ui';

import 'package:aggregator_mobile/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthModel auth;


  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    //WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => FocusScope.of(context).unfocus());

    Timer(Duration(milliseconds: 2000), () async {

      var i = await SharedPreferences.getInstance();
      int id = i.getInt("ID");
      print("id ======. > $id");
      await auth.getUserProfile(id);
      print(auth.user.name);
      print(auth.user.surname);
      print(auth.user.lastname);

      var hasPinCode = await auth.hasPinCode();
      String route = hasPinCode ? Routes.pinCode : Routes.login;

      await Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    auth = Provider.of<AuthModel>(context);

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