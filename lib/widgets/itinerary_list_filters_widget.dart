import 'package:aggregator_mobile/widgets/forms/select_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'date_picker_widget.dart';

class ItineraryListFilter extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ItineraryListFilterState();

}

class ItineraryListFilterState extends State<ItineraryListFilter>{
  DateTime date;
  String from;
  String to;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              SelectLocationField(
                items: ['Москва', 'Владимир', 'Санкт-Петербург'],
                title: 'откуда',
                onChange: (value) => setState((){
                  from = value;
                }),
              ),
              SelectLocationField(
                items: ['Москва', 'Владимир', 'Санкт-Петербург'],
                title: 'куда',
                onChange: (value) => setState((){
                  to = value;
                }),
              )
            ],
          ),
          Row(
            children: [
              CustomDatePicker(
                value: date,
              ),
              // CustomDatePicker(
              //   value: date,
              //   hint: "Дата рождения",
              //   onChange: (value) {
              //     setState(() {
              //       date = value;
              //     });
              //   },
              // ),
              OutlinedButton(
                onPressed: () => print(123),
                child: Text('Поиск', style: TextStyle(color: Colors.white, fontSize: 18),),
                style: OutlinedButton.styleFrom(
                    backgroundColor: Color(0xFF988AAC)
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}