


import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/helpers/date_time_helper.dart';
import 'package:aggregator_mobile/models/history.dart';
import 'package:aggregator_mobile/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ItineraryViewerScreen extends StatefulWidget {
  History history;

  ItineraryViewerScreen(this.history);

  @override
  State<StatefulWidget> createState() {
    return ItineraryViewerScreenState(history);
  }

}


class ItineraryViewerScreenState extends State<ItineraryViewerScreen> {

  History history;
  User _user;

  ItineraryViewerScreenState(this.history);

  @override
  void initState() {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    _user = authModel.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
          titleSpacing: 0.0,
          title: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 50),
            child: Text('Поездка № ${history.trip.id}'),
          ),
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
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
                              Text(history.trip.from, style: TextStyle(color: Color(0xFF667689), fontSize: 22),),
                              Text(DateTimeHelper.getTime(history.trip.start), style: TextStyle(color: Color(0xFFB4B9BF)),)
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
                                Text(history.trip.to, style: TextStyle(color: Color(0xFF667689), fontSize: 22),),
                                Text(DateTimeHelper.getTime(history.trip.finish), style: TextStyle(color: Color(0xFFB4B9BF)),)
                              ],
                            ),
                          )
                      )

                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.today_outlined, color: Color(0xFFB4B9BF)),
                            Text(DateFormat("dd-MM-yyyy").format(history.trip.date), style: TextStyle(color: Color(0xFF667689), fontSize: 16),),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.timelapse, color: Color(0xFFB4B9BF)),
                            Text(DateTimeHelper.getDuration(history.trip.start.difference(history.trip.finish).inMinutes.abs()), style: TextStyle(color: Color(0xFF667689), fontSize: 16)),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.money_rubl, color: Color(0xFFB4B9BF)),
                            Text(history.trip.price.toString(), style: TextStyle(color: Color(0xFF667689), fontSize: 16)),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text('Пассажиры', style: TextStyle(color: Color(0xFF988AAC), fontSize: 24),),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
              alignment: Alignment.centerLeft,
              child: Text('Вы - ${_user.surname} ${_user.name} ${_user.lastname}', style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
            ),
            Builder(
              builder: (BuildContext context) {
                List<Widget> children = [];
                history.passengers.forEach((element) {
                  children.add(
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                        alignment: Alignment.centerLeft,
                        child: Text('${element.surname} ${element.name} ${element.lastname}',
                          style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                      )
                  );
                });
                return Column(
                  children: children,
                );
              },

            ),

            Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text('Места', style: TextStyle(color: Color(0xFF988AAC), fontSize: 24),),
            ),

            Builder(
              builder: (BuildContext context) {
                List<Widget> children = [];
                history.tickets.forEach((element) {
                  children.add(
                    Container(
                      child: Column(
                        children: [

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                              child: Text('${element.row} Ряд, ${element.number} Место',
                                  style: TextStyle(color: Color(0xFF667689), fontSize: 20)
                              )
                          ),
                          Container(
                            //width: 260,
                            //color: Colors.white,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10,),
                                child: QrImage(
                                  backgroundColor: Colors.white,
                                  data: element.code,
                                  version: QrVersions.auto,
                                  size: 250.0,
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    )
                  );
                });
                return Column(
                  children: children,
                );
              },
            ),
          ],
        ),
      )
    );
  }

}