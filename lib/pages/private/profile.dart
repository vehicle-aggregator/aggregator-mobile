import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/pages/onboarding/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  bool isEditMode = false;
  String state = 'default';

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthModel>(context);


    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Профиль'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              auth.logout();
              pushNewScreen(
                context,
                screen: LoginScreen(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            }
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: IntrinsicHeight(
            //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF667689),
                    radius: 52,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('https://pomogaetsrazu.ru/images/offers/2829219234.jpg'),
                      radius: 50,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(auth?.user?.surname ?? '---', style: TextStyle(fontSize: 22, color: Color(0xFF667689)),),
                          Text(auth?.user?.name ?? '---',style: TextStyle(fontSize: 22, color: Color(0xFF667689)),),
                          Text(auth?.user?.lastname ?? '---',style: TextStyle(fontSize: 22, color: Color(0xFF667689)),)
                        ],
                      ),
                    )
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: !this.isEditMode ? Color(0xFF7952B3) : Colors.green,
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      !this.isEditMode ? Icons.edit_rounded : Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        this.isEditMode = !this.isEditMode;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),


          Expanded(
            child: Column(
              children: [
                if (state == 'default')
                  Expanded(
                    flex: state == 'default' ? 8 : 1,
                    child: Container(
                        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.all(const Radius.circular(5)),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text('Email: '),
                                  Text(auth.user.email, style: TextStyle(fontSize: 18, color: Color(0xFF667689)),)
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.all(const Radius.circular(5)),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text('Дата рождения: '),
                                  Text(DateFormat('dd.MM.yyy').format(auth.user.birthDate), style: TextStyle(fontSize: 18, color: Color(0xFF667689)),)
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.all(const Radius.circular(5)),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text('Пол: '),
                                  Text(auth.user.gender == 'male' ? 'Мужской': 'Женский', style: TextStyle(fontSize: 18, color: Color(0xFF667689)),)
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.all(const Radius.circular(5)),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text('Телефон: '),
                                  Text('-', style: TextStyle(fontSize: 18, color: Color(0xFF667689)),)
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                Expanded(
                  flex: state == 'first' ? 9 : 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.all(const Radius.circular(5)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: double.infinity,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      Text("Пассажиры", style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                                      Container(
                                        child: IconButton(
                                          icon: state != 'first' ?  Icon(Icons.keyboard_arrow_down_sharp) : Icon(Icons.keyboard_arrow_up_sharp,),
                                          onPressed: () => setState((){state = state == 'first' ? 'default' : 'first';}),
                                        ),
                                      ),
                                    ]
                                ),
                              )
                            ],
                          )
                      )
                  ),
                ),
                Expanded(
                  flex: state == 'second' ? 9 : 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.all(const Radius.circular(5)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: double.infinity,
                        child: Column(
                          children: [
                            Expanded(
                              flex:1,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Text("Уведомления", style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                                    Container(
                                      child: IconButton(
                                        icon: state != 'second' ?  Icon(Icons.keyboard_arrow_down_sharp) : Icon(Icons.keyboard_arrow_up_sharp,),
                                        onPressed: () => setState((){state = state == 'second' ? 'default' : 'second';}),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            if (state == 'second')
                              Expanded(
                                flex: 7,
                                  child: Container(
                                    height: double.infinity,
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: ListView(
                                      children: <Widget>[
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                        Text('zxc', style: TextStyle(fontSize: 26),),
                                      ],
                                    ),
                                  ),
                              )
                          ],
                        )
                    )


                    // IconButton(
                    //   icon: state != 'second' ?  Icon(Icons.keyboard_arrow_down_sharp) : Icon(Icons.keyboard_arrow_up_sharp,),
                    //   onPressed: () => setState((){
                    //     state = state == 'second' ? 'default' : 'second';
                    //   }),
                    // ),
                  ),
                ),
              ],
            )
          ),
          SizedBox(height: 20,)
        ],
      )



      // body: Center(
      //     child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           Text("Добро пожаловать в приложение\n Оно еще не готово"),
      //           Text("${auth?.user?.email ?? null} --- ${auth?.user?.surname ?? null} --- ${ auth?.user?.lastname ?? null} --- "),
      //           TextButton(
      //               onPressed: () async{
      //                 var i = await SharedPreferences.getInstance();
      //                 var pinCode = i.getString("PIN_CODE");
      //                 setState(() {
      //                   pin = pinCode;
      //                 });
      //               },
      //               style: TextButton.styleFrom(
      //                   backgroundColor: Colors.red
      //               ),
      //               child: Text("Показать пинкод", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
      //           ),
      //           Text(pin ?? ""),
      //           TextButton(
      //               onPressed: () async {
      //                 auth.logout();
      //                 print('logout done');
      //                 pushNewScreen(
      //                   context,
      //                   screen: LoginScreen(),
      //                   withNavBar: false, // OPTIONAL VALUE. True by default.
      //                   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      //                 );
      //                 // await Navigator.pushNamed(context, Routes.login);
      //               },
      //               child: Text("Выйти"))
      //         ]
      //     )
      //
      // ),
    );
  }
}
