import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final labelText;
  final hintText;
  final validator;
  final onSaved;
  final obscureText;
  final keyboardType;
  final controller;
  final padding;
  final error;
  final maxLines;
  final contentPadding;

  const TextFieldWidget({
    Key key,
    this.error,
    this.labelText,
    this.hintText,
    this.validator,
    this.onSaved,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.padding,
    this.maxLines=1,
    this.contentPadding = const EdgeInsets.only(left: 15, top: 0, bottom: 0, right: 15),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            maxLines: this.maxLines,
            onChanged: this.onSaved,
            style: TextStyle(color: Color(0xFF667689)),
            decoration: InputDecoration(
              errorText: error,
              contentPadding: this.contentPadding,
              hintText: this.hintText,
              hintStyle: TextStyle(color: Color(0xFFDCDCDC),),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEDEBF0), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(40))
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEDEBF0), width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(40))
              ),
              focusedErrorBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(40))
              ),
              errorBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(40))
              ),
            ),
            textInputAction: TextInputAction.done,
            validator: this.validator,
            onSaved: this.onSaved,
            obscureText: this.obscureText,
            keyboardType: this.keyboardType,
            controller: this.controller,
            autocorrect: false
          ),
        ],
      ),
    );
  }
}
