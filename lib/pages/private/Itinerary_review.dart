import 'package:aggregator_mobile/api/history_client.dart';
import 'package:aggregator_mobile/helpers/date_time_helper.dart';
import 'package:aggregator_mobile/models/feedback.dart';
import 'package:aggregator_mobile/models/history.dart';
import 'package:aggregator_mobile/widgets/forms/text_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../routes.dart';
import 'balance.dart';

class ItineraryReviewScreen extends StatefulWidget {
  History history;

  ItineraryReviewScreen(this.history);

  @override
  State<StatefulWidget> createState() {
    return ItineraryReviewScreenState(history);
  }

}


class ItineraryReviewScreenState extends State<ItineraryReviewScreen> {
  String title = '';
  String content = '';
  int mark = 0;
  History history;
  HistoryClient client;

  ItineraryReviewScreenState(this.history);

  TextEditingController _controllerTitle, _controllerContent;

  @override
  void initState() {
    client = HistoryClient();
    _controllerContent = TextEditingController(text: '');
    _controllerTitle = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            titleSpacing: 0.0,
            title: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 50),
              child: Text('Поездка № ${history.trip.id}. Отзыв'),
            ),
            iconTheme: IconThemeData(color: Colors.white)
        ),
        body: Container(
          child: SingleChildScrollView(
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
                  child: Text('Оцените поездку', style: TextStyle(color: Color(0xFF988AAC), fontSize: 24),),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            this.mark = 1; // this.mark == 1 ? 0 : 1;
                          });
                        },
                        icon: Icon(Icons.star, size: 40, color: this.mark >= 1 ? Theme.of(context).primaryColor : Colors.grey),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            this.mark = 2; //this.mark == 2 ? 0 : 2;
                          });
                        },
                        icon: Icon(Icons.star, size: 40, color: this.mark >= 2 ? Theme.of(context).primaryColor : Colors.grey),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            this.mark = 3; //this.mark == 3 ? 0 : 3;
                          });
                        },
                        icon: Icon(Icons.star, size: 40, color: this.mark >= 3 ? Theme.of(context).primaryColor : Colors.grey),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            this.mark = 4; //this.mark == 4 ? 0 : 4;
                          });
                        },
                        icon: Icon(Icons.star, size: 40, color: this.mark >= 4 ? Theme.of(context).primaryColor : Colors.grey),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            this.mark = 5; //this.mark == 5 ? 0 : 5;
                          });
                        },
                        icon: Icon(Icons.star, size: 40, color: this.mark >= 5 ? Theme.of(context).primaryColor : Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text('Оставьте отзыв', style: TextStyle(color: Color(0xFF988AAC), fontSize: 24),),
                ),


                Container(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: TextFieldWidget(
                    key: Key('title'),
                    hintText: "Тема",
                    onSaved: (value) {setState(() {
                      title = value;
                    });},
                    controller: _controllerTitle,
                    keyboardType: TextInputType.text,
                  ),
                ),


                Container(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: TextFieldWidget(
                    keyboardType: TextInputType.multiline,
                    contentPadding: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
                    maxLines: 5,
                    key: Key('content'),
                    hintText: "Текст отзыва",
                    onSaved: (value) {setState(() {
                      content = value;
                    });},
                    controller: _controllerContent,
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: OutlinedButton(
                    onPressed:
                    title.isNotEmpty && content.isNotEmpty ?
                        () async
                    {
                      Feed f = Feed(title: this.title, mark: this.mark, content: this.content, tripId: history.trip.id);
                      client.addFeedback(f.toJson());
                      await Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                          builder: (BuildContext context) {
                            return BalanceScreen();
                          },
                        ), (_) => false,
                      );


                      //await Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => false);
                    } : null,
                    child: Text('Отправить отзыв', style: TextStyle(color: Colors.white, ),),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states){
                          if (states.contains(MaterialState.disabled))
                            return Colors.grey;
                          return Colors.green;
                        },
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        )
    );
  }

}