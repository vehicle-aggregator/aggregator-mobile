import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/pages/onboarding/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes.dart';
import 'navigation/bottom_navigation.dart';
import 'navigation/tab_item.dart';

class ProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<ProfileScreen>{
  AuthModel auth;
  String pin;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthModel>(context);


    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Добро пожаловать в приложение\n Оно еще не готово"),
                Text("${auth?.user?.email ?? null} --- ${auth?.user?.surname ?? null} --- ${ auth?.user?.lastname ?? null} --- "),
                TextButton(
                    onPressed: () async{
                      var i = await SharedPreferences.getInstance();
                      var pinCode = i.getString("PIN_CODE");
                      setState(() {
                        pin = pinCode;
                      });
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red
                    ),
                    child: Text("Показать пинкод", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                ),
                Text(pin ?? ""),
                TextButton(
                    onPressed: () async {
                      auth.logout();
                      print('logout done');
                      pushNewScreen(
                        context,
                        screen: LoginScreen(),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                      // await Navigator.pushNamed(context, Routes.login);
                    },
                    child: Text("Выйти"))
              ]
          )

      ),
    );
  }
}
