import 'package:aggregator_mobile/api/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation/bottom_navigation.dart';
import 'navigation/tab_item.dart';

class BalanceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BalanceState();
}

class BalanceState extends State<BalanceScreen>{
  AuthModel auth;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Container(
            child: Text('Баланс'),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.account_balance_wallet),
              onPressed: () => setState((){
                print('asdasd');
              }),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5), borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ваш баланс:', style: TextStyle(fontSize: 16, color: Color(0xFF667689)),),
                        Container(
                          child: Row(
                            children: [
                              Text(auth.user.balance.toString(), style: TextStyle(fontSize: 24, color: Color(0xFF667689)),),
                              Icon(CupertinoIcons.money_rubl, color: Color(0xFF667689))
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 48,
                      child: OutlinedButton(
                          onPressed: () => print(123),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.green,
                            side: BorderSide(color: Colors.green),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.white,),
                              Text('Пополнить', style: TextStyle(color: Colors.white, fontSize: 18),)
                            ],
                          )
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                    child: Text('Доступно 120 бонусов спасибо', style: TextStyle(color: Color(0xFF667689)),)
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('История оплат', style: TextStyle(color: Color(0xFF988AAC), fontSize: 24),),
                IconButton(
                    onPressed: () => print(123),
                    icon: Icon(Icons.delete, color: Colors.red,)
                )
              ],
            ),
          ),
          Expanded(
              child: ListView(
                children: [
                  HistoryItem(),
                  HistoryItem(),
                  HistoryItem(),
                  HistoryItem(),HistoryItem(),HistoryItem(), SizedBox(height: 20,)
                ],
              )
          )

        ],
      )
    );
  }
}

class HistoryItem extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFF5F5F5), borderRadius: BorderRadius.all(Radius.circular(15))),
        margin: EdgeInsets.only(left: 15, right: 15, top:15),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child:Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Владимир',//item.from,
                          style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                        Text(
                          '13:00',
                          //getTime(item.start),
                          style: TextStyle(color: Color(0xFFB4B9BF)),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Icon(Icons.arrow_forward_rounded, color: Color(0xFFB4B9BF),)),
                ),

                Expanded(
                    flex: 5,
                    child: Container(
                      //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Ковров',
                            //item.to,
                            style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                          Text(
                            '15:00',
                            //getTime(item.finish),
                            style: TextStyle(color: Color(0xFFB4B9BF)),
                          )
                        ],
                      ),
                    )
                )

              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Flexible(
                  flex:5,
                  child: Column(

                    children: [
                      Container(
                        width: double.infinity,
                        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                        child: Wrap(
                          direction: Axis.horizontal,
                          //crossAxisAlignment: WrapCrossAlignment.start,
                          //alignment: WrapAlignment.start,
                          children: [
                            Container(
                              width: 110,
                              child: Row(
                                children: [
                                  Icon(Icons.today_outlined, color: Color(0xFFB4B9BF)),
                                  Text(
                                    '22-04-2022',
                                    //DateFormat("dd-MM-yyyy").format(item.date),
                                    style: TextStyle(color: Color(0xFFB4B9BF)),),
                                ],
                              ),
                            ),
                            Container(

                                width: 90,
                                child: Row(
                                  children: [
                                    Icon(Icons.timelapse, color: Color(0xFFB4B9BF),),
                                    Text(
                                      '2ч 30м',
                                      //getDuration(item.start.difference(item.finish).inMinutes.abs()),
                                      style: TextStyle(color: Color(0xFFB4B9BF)),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.green
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, color: Colors.white),
                              Text('Завершено', style: TextStyle(color: Colors.white))
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.money_rubl, color: Color(0xFF667689), size: 32,),
                          Text(
                            '1000',
                            //item.price.toString(),
                            style: TextStyle(color: Color(0xFF667689), fontSize: 26),)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('+ 135', style: TextStyle(color:Color(0xFFB4B9BF))),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xFFB4B9BF)
                            ),
                              onPressed: () => print(678),
                              child: Icon(Icons.menu,color: Colors.white,)
                          )
                        ]
                      )
                    ],
                  ),

                )
              ],
            ),

          ],
        )
    );
  }

}