import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/components/dialogs/passenger_create_dialog.dart';
import 'package:aggregator_mobile/models/user.dart';
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
                      backgroundImage: NetworkImage('https://media.istockphoto.com/vectors/photo-camera-icon-with-long-shadow-on-blank-background-flat-design-vector-id1383135927?b=1&k=20&m=1383135927&s=612x612&w=0&h=XFLsQPmQVNQVGtecXhFECC_WIOOtNC2QPaheGg60Fsg='),
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
                              ),
                              if (state == 'first')
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    height: double.infinity,
                                    margin: EdgeInsets.only(bottom: 10),
                                      child: ListView.builder(
                                        physics: AlwaysScrollableScrollPhysics(),
                                        itemCount:  auth?.user?.passengers?.length ??  1,
                                        itemBuilder: (context, index) {
                                          final item = auth?.user?.passengers[index] ?? null;
                                          return PassengerItem(key: Key(index.toString()), item: item);
                                        },
                                      )
                                  ),
                                ),
                              if (state == 'first')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      height: 48,
                                      child: OutlinedButton(
                                          onPressed: () async {
                                            var result = await showDialog(
                                                context: context,
                                                builder: (builderContext) => PassengerCreateDialog()
                                            );
                                            if (result){
                                              var instance = await SharedPreferences.getInstance();
                                              await this.auth.getUserProfile(instance.getInt('ID'));
                                              setState(() {});
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            side: BorderSide(color: Colors.green),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.add, color: Colors.white,),
                                              Text('Добавить', style: TextStyle(color: Colors.white, fontSize: 18),)
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
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
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: ListView(
                                      children: <Widget>[
                                        NotificationItem(key: Key(1.toString()), text: 'Поездка №5 окончена'),
                                        NotificationItem(key: Key(1.toString()), text: 'Поездка №5 запланирована на 21.04.2022 12:00'),
                                        NotificationItem(key: Key(1.toString()), text: 'Приобретено 3 билета на поездку №5'),
                                        NotificationItem(key: Key(1.toString()), text: 'Начислено 25 бонусов спасибо'),
                                        NotificationItem(key: Key(1.toString()), text: 'Воспользуйтесь новой акцией на междугородние поездки')
                                      ],
                                    ),
                                  ),
                              )
                          ],
                        )
                    )
                  ),
                ),
              ],
            )
          ),
          SizedBox(height: 20,)
        ],
      )

    );
  }
}

class PassengerItem extends StatelessWidget{
  final Passenger item;

  const PassengerItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item == null)
      return Padding(
        padding: EdgeInsets.all(8),
        child: Text('Ни одного пассажира пока что не было добавлено', style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
      );
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFFF5F5F5), borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        margin: EdgeInsets.only(bottom:15),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child:Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.surname, style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                        Text('${item.name} ${item.lastname}', style: TextStyle(color: Color(0xFFB4B9BF)),)
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'Лет: ${DateTime.now().year - item.birthDate.year}',
                    //'Лет: 21',
                    style: TextStyle(color: Color(0xFF667689), fontSize: 16),
                  ),
                )
              ],
            ),
          ],
        )
    );
  }
}

class NotificationItem extends StatelessWidget{
  final String text;

  const NotificationItem({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFFF5F5F5), borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        margin: EdgeInsets.only(bottom:15),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('21-04-2022 12:30', style: TextStyle(color: Color(0xFFB4B9BF)),)
                ),
                Container(
                  child: Icon(Icons.circle, color: Colors.blue, size: 20)
                )
              ],
            ),
            Container(
              //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Text(text, style: TextStyle(color: Color(0xFF667689), fontSize: 18))
            )
            //SizedBox(height: 10,)
          ],
        )
    );
  }
}
