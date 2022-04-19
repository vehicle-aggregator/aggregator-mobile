import 'dart:math';

import 'package:aggregator_mobile/components/dialogs/booking_confirm_dialog.dart';
import 'package:aggregator_mobile/models/bus.dart';
import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../routes.dart';
import 'itinerary_list.dart';

const Map<String,Color> placesColors = const {
  'vacant': Colors.white,
  'engaged': Colors.grey,
  'me': Colors.green
};

class BookingScreen extends StatefulWidget{
  final Itinerary trip;

  const BookingScreen(this.trip);

  @override
  State<StatefulWidget> createState() => BookingState(trip);
}

class BookingState extends State<BookingScreen>{
  final Itinerary trip;
  Bus bus = Bus([]);
  int order = 0;

  BookingState(this.trip);

  @override
  void initState() {

    order = 0;
    for (int i = 1; i <= 12; i++){
      Line line = Line(places: []);
      for (int j = 1; j <= (i==12 ? 5 : 4); j++){
        order++;
        var r = Random().nextInt(10) + order-5;
        Place place = Place(number: order, status: order >= r ? 'vacant' : 'engaged');
        line.places.add(place);
      }
      bus.lines.add(line);
    }
    super.initState();
  }

  String getTime(DateTime date){
    return (DateFormat('HH:mm').format(date));
  }

  String getDuration(int minutes){
    return '${minutes ~/ 60} ч ${minutes % 60} м';
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
              child: Text('Покупка билета'),
            ),
            iconTheme: IconThemeData(color: Colors.white)
        ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
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
                            Text(trip.from, style: TextStyle(color: Color(0xFF667689), fontSize: 22),),
                            Text(getTime(trip.start), style: TextStyle(color: Color(0xFFB4B9BF)),)
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
                              Text(trip.to, style: TextStyle(color: Color(0xFF667689), fontSize: 22),),
                              Text(getTime(trip.finish), style: TextStyle(color: Color(0xFFB4B9BF)),)
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
                          Text(DateFormat("dd-MM-yyyy").format(trip.date), style: TextStyle(color: Color(0xFF667689), fontSize: 16),),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.timelapse, color: Color(0xFFB4B9BF)),
                          Text(getDuration(trip.start.difference(trip.finish).inMinutes.abs()), style: TextStyle(color: Color(0xFF667689), fontSize: 16)),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.money_rubl, color: Color(0xFFB4B9BF)),
                          Text(trip.price.toString(), style: TextStyle(color: Color(0xFF667689), fontSize: 16)),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(20)
              ),
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              padding: EdgeInsets.all(20),
              child: Builder(
                builder: (BuildContext context){
                  List<Widget> children = [];

                  bus.lines.forEach((line) {
                    line.places.forEach((place) {
                      children.add(
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).primaryColor),
                              color: placesColors[place.status]
                          ),
                          child: InkWell(
                            onTap: place.status == 'engaged' ? null : () {
                              setState(() {
                                place.status = place.status == 'vacant' ? 'me' : 'vacant';
                              });
                            },
                            child: Center(child: Text(place.number.toString())),
                          ),
                        )
                      );
                      if (place.number % 4 == 2 && place.number < order - 5)
                        children.add(Container(color: Color(0xFFF5F5F5)));
                    });
                  });


                  return GridView.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: children
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          bus.lines.forEach((line) {
                            line.places.forEach((place) {
                              if (place.status == 'me')
                                place.status = 'vacant';
                            });
                          });
                        });
                      },
                      child: Text('Сбросить', style: TextStyle(color: Colors.red),),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () async {

                        List<Place> places = [];
                        bus.lines.forEach((line) {
                          line.places.forEach((place) {
                            if (place.status == 'me')
                              places.add(place);
                          });
                        });

                        var result = await showDialog(
                          context: context,
                          builder: (builderContext) => BookingConfirmDialog(
                              itinerary: trip,
                              places: places
                          )
                        );

                        if (result == true){
                          await Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => false);
                        }
                      },
                      child: Text('Подтвердить покупку', style: TextStyle(color: Colors.white, ),),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ) ,
    );
  }

}