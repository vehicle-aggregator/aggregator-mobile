import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/bloc/bloc.dart';
import 'package:aggregator_mobile/bloc/booking_bloc.dart';
import 'package:aggregator_mobile/components/dialogs/booking_confirm_dialog.dart';
import 'package:aggregator_mobile/models/bus.dart';
import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:aggregator_mobile/models/user.dart';
import 'package:aggregator_mobile/widgets/row_with_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

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
  int order = 0;
  BookingBloc _bloc;
  User _user;

  BookingState(this.trip);

  @override
  void initState() {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    _user = authModel.user;
    _bloc = BookingBloc();
    _bloc.init(trip.id, _user);
    super.initState();

    // order = 0;
    // for (int i = 1; i <= 12; i++){
    //   Line line = Line(places: []);
    //   for (int j = 1; j <= (i==12 ? 5 : 4); j++){
    //     order++;
    //     var r = Random().nextInt(10) + order-5;
    //     Place place = Place(number: order, status: order >= r ? 'vacant' : 'engaged');
    //     line.places.add(place);
    //   }
    //   bus.lines.add(line);
    // }
    // super.initState();
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
      body: StreamBuilder<BookingUiState>(
        stream: _bloc.stream,
        initialData: BookingUiState.loading(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          Bus bus = snapshot.data?.uiData?.bus;
          List<Passenger> currentPassengers = snapshot.data?.uiData?.passengers;
          return  Column(
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Баланс:', style: TextStyle(color: Color(0xFF667689), fontSize: 18)),
                      Container(
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.money_rubl, color: Color(0xFFB4B9BF)),
                            Text(_user.balance.toString(),
                                style: TextStyle(
                                    decoration: (bus?.seats ?? []).any((e) => e.status == 'me') ? TextDecoration.lineThrough : null,
                                    color: Color(0xFF667689),
                                    fontSize: 18
                                )
                            ),

                            if ((bus?.seats ?? []).any((e) => e.status == 'me'))
                              Row(
                                children: [
                                  Icon(Icons.arrow_forward_rounded, color: Color(0xFFB4B9BF)),
                                  Icon(CupertinoIcons.money_rubl, color: Color(0xFFB4B9BF)),
                                  Text(
                                      (_user.balance - bus.seats.where((e) => e.status == 'me').length * trip.price).toString(),
                                      style: TextStyle(color: Color(0xFF667689), fontSize: 18)
                                  ),
                                ],
                              )

                          ],
                        ),
                      )
                    ]
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.all(20),
                  child: Builder(
                    builder: (BuildContext context){
                      if (snapshot.data.uiState == UiState.loading)
                        return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
                      if (bus.seats.isEmpty)
                        return Text('Автобус еще не добавлен');

                      List<Widget> children = [];
                      bus.seats.forEach((place) {
                        children.add(
                            place.show
                                ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                  border: Border.all(color: Theme.of(context).primaryColor),
                                  color: placesColors[place.status]
                              ),
                              child: InkWell(
                                onTap: place.status == 'engaged' ? null : () {
                                  _bloc.selectPlace(place.id, place.status == 'vacant');
                                },
                                child: Center(child: Text(place.number.toString())),
                              ),
                            )
                                : Container(color: Color(0xFFF5F5F5))
                        );
                      });

                      return GridView.count(
                          crossAxisCount: bus.seats.where((element) => element.row == 1).length,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: children
                      );
                    },
                  ),
                ),
              ),



              if ((bus?.seats ?? []).isNotEmpty && snapshot.data.uiState != UiState.loading && bus.seats.any((element) => element.status == 'me'))
                Container(
                  child: RowWithItems(
                    items: currentPassengers,
                    chooseFrom: _user.passengers.where((element) => !currentPassengers.any((cp)=> cp.id == element.id)).toList(),
                    onChange: (val) {
                      if (!val.contains(null))
                        _bloc.changePassengers(val);
                    },
                    plus: bus.seats.where((element) => element.status == 'me').length > 1 &&
                        bus.seats.where((element) => element.status == 'me').length != currentPassengers.length,
                  ),
                ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            _bloc.clear(_user);
                          },
                          child: Text('Сбросить', style: TextStyle(color: Colors.red),),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 48,
                        child: OutlinedButton(
                          onPressed:
                          (bus?.seats ?? []).any((element) => element.status == 'me') &&
                              _user.balance >= (bus.seats.where((e) => e.status == 'me').length * trip.price) &&
                              currentPassengers.length == bus.seats.where((e) => e.status == 'me').length
                              ? () async
                          {

                            List<Seat> mySeats = [];
                            bus.seats.forEach((seat) {
                              if (seat.status == 'me')
                                mySeats.add(seat);
                            });

                            var result = await showDialog(
                                context: context,
                                builder: (builderContext) => BookingConfirmDialog(
                                    itinerary: trip,
                                    places: mySeats,
                                    onConfirm: () async {
                                      await _bloc.buyTicket(trip.id, mySeats, currentPassengers);
                                      //await Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => false);
                                    },
                                    passengers: currentPassengers
                                )
                            );
                            //
                             if (result == true){
                               await Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => false);
                            }
                          } : null,
                          child: Text('Подтвердить покупку', style: TextStyle(color: Colors.white, ),),
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
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}