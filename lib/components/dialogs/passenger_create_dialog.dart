import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/api/passenger_client.dart';
import 'package:aggregator_mobile/models/bus.dart';
import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:aggregator_mobile/models/user.dart';
import 'package:aggregator_mobile/widgets/date_picker_widget.dart';
import 'package:aggregator_mobile/widgets/forms/text_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PassengerCreateDialog extends StatefulWidget {

  const PassengerCreateDialog({Key key,}) : super(key: key);

  @override
  _BookingConfirmDialogState createState() => _BookingConfirmDialogState();
}

class _BookingConfirmDialogState extends State<PassengerCreateDialog> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offsetAnimation;
  Passenger passenger;
  PassengerClient client;
  bool error = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    // _user = authModel.user;
    passenger = Passenger();
    client = PassengerClient();

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
                        child: Text('Добавление пассажира', style: TextStyle(fontSize: 22),),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      ListTile(
                        title: TextFieldWidget(
                            key: Key('name'),
                            hintText: "Имя",
                            onSaved: (val) => setState(() => this.passenger.name = val),
                            keyboardType: TextInputType.text,
                            //error: this.nameError
                        ),
                      ),
                      ListTile(
                        title: TextFieldWidget(
                          key: Key('surname'),
                          hintText: "Фамилия",
                          onSaved: (val) => setState(() => this.passenger.surname = val),
                          keyboardType: TextInputType.text,
                          //error: this.surnameError,
                        ),
                      ),
                      ListTile(
                        title: TextFieldWidget(
                          key: Key('lastname'),
                          hintText: "Отчество",
                          onSaved: (val) => setState(() => this.passenger.lastname = val),
                          keyboardType: TextInputType.text,
                          //error: this.lastnameError,
                        ),
                      ),
                      ListTile(
                        title: CustomDatePicker(
                          value: this.passenger?.birthDate,
                          hint: "Дата рождения",
                          onChange: (value) {
                            setState(() {
                              this.passenger.birthDate = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Color(0xFFEDEBF0), width: 1),
                          ),
                          width: MediaQuery.of(context).size.width - 32,
                          child: ButtonTheme(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Text("Документ", style: TextStyle(color: Color(0xFFDCDCDC))),
                                ),
                                value: this.passenger?.doctype,
                                isExpanded: true,
                                icon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Icon(Icons.keyboard_arrow_down, color: this.passenger?.doctype == null ? Color(0xFFDCDCDC) :Color(0xFF667689),),
                                ),
                                iconSize: 25,
                                style: TextStyle(
                                  color: Color(0xFF667689),
                                  fontSize: 16,
                                ),
                                onChanged: (value) => setState(() => this.passenger?.doctype = value ?? "Паспорт"),
                                items: ['Паспорт', 'Св. о рождении'].map<DropdownMenuItem<String>>((String value) =>
                                    DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Text(value)
                                        )
                                    )
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextFieldWidget(
                          key: Key('docdetail'),
                          hintText: "Серия и номер",
                          onSaved: (val) => setState(() => this.passenger.docdetail = val),
                          keyboardType: TextInputType.number,
                          //error: this.lastnameError,
                        ),
                      ),



                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
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
                                    onPressed: !this.passenger.isValid() ? null
                                        :() async {
                                          var result = await client.addPassenger(this.passenger);
                                          if (result)
                                            Navigator.pop(context, true);
                                          else
                                            error = true;
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

                      if (error)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Произошла ошибка', style: TextStyle(color: Colors.red, fontSize: 18),),
                        )
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

}