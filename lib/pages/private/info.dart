import 'package:aggregator_mobile/api/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes.dart';

class Info extends StatefulWidget{

  @override
  InfoState createState() => InfoState();

}

class InfoState extends State<Info>{
  AuthModel auth;
  String pin;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthModel>(context);


    return Material(
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Добро пожаловать в приложение\n Оно еще не готово"),
                Text("${auth.user.email} --- ${auth.user.surname} --- ${ auth.user.lastname} --- "),
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
                      await Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (route) => false);
                    },
                    child: Text("Выйти"))
              ]
          )

      ),
    );
  }
}