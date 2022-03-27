import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateChangedCallback onChange;
  final DateTime value;
  final String hint;
  final DateTime minTime;
  final DateTime maxTime;

  CustomDatePicker(
      {this.value,
        this.minTime,
        this.maxTime,
        this.hint,
        @required this.onChange});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {

    var currentDateLabel = widget.value == null
        ? widget.hint
        : DateFormat("dd-MM-yyyy").format(widget.value);

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: widget.minTime,
                  maxTime: widget.maxTime, onCancel: () {
                    setState(() => _value = null);
                    return this.widget.onChange(null);
                  },
                  onConfirm: (date) {
                    setState(() => _value = date);
                    return this.widget.onChange(date);
                  },
                  currentTime: _value ?? DateTime.now(), locale: LocaleType.ru
              );
            },
            child: Container(
                padding: EdgeInsets.only(left: 15, top: 8, bottom: 12, right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Color(0xFFEDEBF0), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currentDateLabel,
                        style: TextStyle(
                            color: widget.value == null ? Color(0xFFDCDCDC) : Color(0xFF667689),
                            fontSize: 16,
                            height: 24 / 16
                        )
                    ),
                    Icon(Icons.today_rounded,
                        size: 25,
                        color: widget.value == null ? Color(0xFFDCDCDC) :Color(0xFF667689)
                    ),
                  ],
                )
            ),
          ),
        ]
    );
  }
}