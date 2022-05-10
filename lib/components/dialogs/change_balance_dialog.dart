import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/api/balance_client.dart';
import 'package:aggregator_mobile/models/bank_card.dart';
import 'package:aggregator_mobile/models/bus.dart';
import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:aggregator_mobile/models/user.dart';
import 'package:aggregator_mobile/widgets/date_picker_widget.dart';
import 'package:aggregator_mobile/widgets/forms/text_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChangeBalanceDialog extends StatefulWidget {

  const ChangeBalanceDialog({Key key,}) : super(key: key);

  @override
  _ChangeBalanceDialogState createState() => _ChangeBalanceDialogState();
}

class _ChangeBalanceDialogState extends State<ChangeBalanceDialog> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offsetAnimation;
  BankCard card;
  User _user;
  BalanceClient client;
  bool error = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
     _user = Provider.of<AuthModel>(context, listen: false).user;
    card = BankCard();
    client = BalanceClient();

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
    return Dialog(
        insetPadding: EdgeInsets.only(top: 0),
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
                        child: Text('Пополнение баланса', style: TextStyle(fontSize: 22),),
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
                //height: mq.size.height - 185 - mq.padding.top - mq.padding.bottom,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5) ,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Баланс:', style: TextStyle(color: Color(0xFF667689), fontSize: 18,),),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.money_rubl, color: Color(0xFF667689), size: 22),
                                    Text(this._user.balance.toString(),
                                      style: TextStyle(
                                          color: Color(0xFF667689), fontSize: 18,
                                          decoration: this.card.sum != null ? TextDecoration.lineThrough : TextDecoration.none
                                      ),
                                    ),
                                    if (this.card.sum != null)
                                      Icon(Icons.arrow_forward_rounded, color: Color(0xFF667689),),
                                    if (this.card.sum != null)
                                      Icon(CupertinoIcons.money_rubl, color: Color(0xFF667689), size: 22),
                                    if (this.card.sum != null)
                                      Text((this._user.balance + this.card.sum).toString(),
                                        style: TextStyle(color: Color(0xFF667689), fontSize: 18,),
                                      ),
                                  ],
                                ),
                              )

                            ],
                          )
                      ),

                      ListTile(
                        title: TextFieldWidget(
                          key: Key('name'),
                          hintText: "Номер карты",
                          onSaved: (val) => setState(() => this.card.number = val),
                          keyboardType: TextInputType.number,
                          //error: this.nameError
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                title: TextFieldWidget(
                                  key: Key('surname'),
                                  hintText: "ММ/ГГ",
                                  onSaved: (val) => setState(() => this.card.activeTo = val),
                                  keyboardType: TextInputType.text,
                                  //error: this.surnameError,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                title: TextFieldWidget(
                                  key: Key('lastname'),
                                  hintText: "CVV",
                                  onSaved: (val) => setState(() => this.card.cvv = val),
                                  keyboardType: TextInputType.number,
                                  //error: this.lastnameError,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),




                      ListTile(
                        title: TextFieldWidget(
                          key: Key('Summ'),
                          hintText: "Сумма пополнения",
                          onSaved: (val) => setState(() {
                            this.card.sum = val == '' ? null : int.parse(val);
                          }),
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
                                    onPressed: !this.card.isValid()
                                        ? null :() async {
                                      var result = await client.changeBalance(this.card.sum);
                                      if (result)
                                        Navigator.pop(context, true);
                                      else error=true;
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
      );
  }
}