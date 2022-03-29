import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';

class PinCode extends StatefulWidget {
  final Function onEnter;
  final bool enabled;

  @override
  _PinCodeState createState() => _PinCodeState();

  PinCode({this.onEnter, this.enabled, Key key}) : super(key: key);
}

class _PinCodeState extends State<PinCode> {
  int level = 0;

  TextEditingController codeController;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    codeController.addListener(() {
      if (!widget.enabled) return;

      var text = codeController.text;
      setState(() {
        level = text.length > 4 ? 4 : text.length;
        if (this.level == 4) {
          level = 0;
          widget.onEnter(text);
        }
      });
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pin(this.level > 0),
                    Pin(this.level > 1),
                    Pin(this.level > 2),
                    Pin(this.level > 3),
                  ],
                ),
                NumericKeyboard(
                  rightIcon: Icon(
                    Icons.backspace,
                    color: Colors.black,
                  ),
                  rightButtonFn: () {
                    var text = codeController.value.text;
                    if (text.length == 0) return;
                    text = text.substring(0, text.length - 1);
                    setState(() => codeController.text = text);
                  },
                  onKeyboardTap: (String text) {
                    setState(() {
                      var newValue = codeController.value.text + text;
                      codeController.text = newValue;
                    });
                  },
                )
              ],
            ),
            Opacity(
                opacity: 0.0,
                child: TextField(
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: false,
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                  controller: codeController,
                )
            ),
          ]
      ),
    );
  }
}

class Pin extends StatelessWidget {
  final bool filled;

  const Pin(this.filled);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);

    return Container(
        width: 15,
        height: 15,
        margin: EdgeInsets.only(left: 24, right: 24),
        decoration: BoxDecoration(
          color: this.filled ? Color(0xFF7952B3) : Color(0xFFDCDCDC),
          shape: BoxShape.circle,
        )
    );
  }
}