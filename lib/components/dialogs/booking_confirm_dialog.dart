import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/models/bus.dart';
import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:aggregator_mobile/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingConfirmDialog extends StatefulWidget {
  final Itinerary itinerary;
  final List<Seat> places;
  final List<Passenger> passengers;

  const BookingConfirmDialog({
    Key key,
    @required this.places,
    @required this.passengers,
    @required this.itinerary,
  }) : super(key: key);

  @override
  _BookingConfirmDialogState createState() => _BookingConfirmDialogState();
}

class _BookingConfirmDialogState extends State<BookingConfirmDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offsetAnimation;
  User _user;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    _user = authModel.user;

    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return SlideTransition(
      position: offsetAnimation,
      child: Dialog(
        insetPadding: EdgeInsets.only(top: 70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Потверждение покупки', style: TextStyle(fontSize: 22),),
                      ),
                    ),
                    CupertinoButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(Icons.close, size: 24, color: Colors.black)
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                width: double.infinity,
                height: mq.size.height - 185 - mq.padding.top - mq.padding.bottom,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5) ,
                          child: Text('Номер рейса: ${this.widget.itinerary.id}', style: TextStyle(fontSize: 16),)
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5) ,
                        child:Text('Откуда: ${this.widget.itinerary.from}', style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5) ,
                        child:Text('Куда: ${this.widget.itinerary.to}', style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5) ,
                        child:Text('Дата и время отбытия: ${DateFormat("dd-MM-yyyy HH:mm").format(widget.itinerary.start)}', style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5) ,
                        child:Text('Дата и время прибытия: ${DateFormat("dd-MM-yyyy HH:mm").format(widget.itinerary.finish)}', style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5) ,
                        child:Text('Компания перевозчик: ${this.widget.itinerary.transporter}', style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5) ,
                        child:Text('Покупатель: ${_user.surname} ${_user.name} ${_user.lastname} ', style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5) ,
                        child:Text('Контактный адрес: ${_user.email}', style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5,),
                          child: Text('Пассажиры:',style: TextStyle(fontSize: 16))
                      ),
                      Divider(),
                      Builder(
                        builder: (BuildContext context){
                          List<Widget> people =[];
                          widget.passengers.forEach((element) {
                            people.add(
                              Container(
                                child: Text('${element.surname} ${element.name} ${element.lastname}',style: TextStyle(fontSize: 16)),
                              )
                            );
                          });
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: people);
                        },
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Итого:', style: TextStyle(fontSize: 16)),
                            Text('${widget.passengers.length} мест(а)', style: TextStyle(fontSize: 18))
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 5,),
                          child: Text('Места:',style: TextStyle(fontSize: 16))
                      ),
                      Divider(),
                      Builder(
                        builder: (BuildContext context){
                          List<Widget> tickets =[];
                          widget.places.forEach((element) {
                            tickets.add(
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Ряд: ${element.row}, Место: ${element.number}',style: TextStyle(fontSize: 16)),
                                    Text('${widget.itinerary.price} р',style: TextStyle(fontSize: 18))
                                  ],
                                ),
                              )
                            );
                          });
                          return Column(children: tickets);
                        },
                      ),
                      Divider(),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Итого:', style: TextStyle(fontSize: 16)),
                            Text('${widget.itinerary.price * widget.places.length} р', style: TextStyle(fontSize: 18))
                          ],
                        ),
                      ),




                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                style: outlineButtonStyle(),
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'Отмена',
                                  style: TextStyle(color: Colors.red, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(
                                      'Подтвердить',
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isNotEmpty(String value) => value != null && value.isNotEmpty;

}

ButtonStyle outlineButtonStyle() {
  return OutlinedButton.styleFrom(
    textStyle: TextStyle(color: Color(0xFF4D43B2)),
    primary: Color(0xFF4D43B2),
    minimumSize: Size(88, 50),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  ).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
        return BorderSide(
          color: Colors.red,
          width: 1,
        );
      },
    ),
  );
}