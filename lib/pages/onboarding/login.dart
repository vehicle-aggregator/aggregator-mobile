import 'package:aggregator_mobile/models/user.dart';
import 'package:aggregator_mobile/widgets/date_picker_widget.dart';
import 'package:aggregator_mobile/widgets/forms/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  bool registration = false;
  User _user;
  String passwordError;
  String emailError;
  String loginError;
  String nameError;
  String surnameError;

  //AuthModel _auth;

  TextEditingController _controllerEmail, _controllerPassword, _controllerConfirm;

  @override
  void initState() {
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
    _controllerConfirm = TextEditingController();
    _user = User();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_auth = Provider.of<AuthModel>(context);

    var mq = MediaQuery.of(context);


    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  SvgPicture.asset('assets/svg/logo_black.svg', width: 150, height: 150),
                  SizedBox(height: 30,), // TODO STAND CHANGING
                  Container(
                    padding: EdgeInsets.symmetric( horizontal: MediaQuery.of(context).size.width / 10),
                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: TextFieldWidget(
                            key: Key('login'),
                            labelText: "Логин",
                            hintText: "Логин",
                            onSaved: (val) => setState(() => this._user.login = val),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            controller: _controllerEmail,
                            error: loginError,
                          ),
                        ),
                        if (!this.registration)
                          ListTile(
                            title: TextFieldWidget(
                              key: Key('пароль'),
                              labelText: "Пароль",
                              hintText: "Пароль",
                              onSaved: (val) => setState(() => this._password = val),
                              obscureText: true,
                              controller: _controllerPassword,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        if (this.registration)
                          Column(
                            children: [
                              ListTile(
                                title: TextFieldWidget(
                                  key: Key('email'),
                                  hintText: "E-mail",
                                  onSaved: (val) => setState(() => this._user.email = val),
                                  keyboardType: TextInputType.text,
                                  error: this.emailError,
                                ),
                              ),
                              ListTile(
                                title: TextFieldWidget(
                                  key: Key('name'),
                                  hintText: "Имя",
                                  onSaved: (val) => setState(() => this._user.name = val),
                                  keyboardType: TextInputType.text,
                                  error: this.nameError
                                ),
                              ),
                              ListTile(
                                title: TextFieldWidget(
                                  key: Key('surname'),
                                  hintText: "Фамилия",
                                  onSaved: (val) => setState(() => this._user.surname = val),
                                  keyboardType: TextInputType.text,
                                  error: this.surnameError,
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
                                          child: Text("Пол", style: TextStyle(color: Color(0xFFDCDCDC))),
                                        ),
                                        value: _user.gender,
                                        isExpanded: true,
                                        icon: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Icon(Icons.keyboard_arrow_down, color: _user.gender == null ? Color(0xFFDCDCDC) :Color(0xFF667689),),
                                        ),
                                        iconSize: 25,
                                        style: TextStyle(
                                            color: Color(0xFF667689),
                                            fontSize: 16,
                                        ),
                                        onChanged: (value) => setState(() => _user.gender = value ?? "Мужской"),
                                        items: ['Мужской', 'Женский'].map<DropdownMenuItem<String>>((String value) =>
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
                                title: CustomDatePicker(
                                  value: _user.birthDate,
                                  hint: "Дата рождения",
                                  onChange: (value) {
                                    setState(() {
                                      _user.birthDate = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: TextFieldWidget(
                                  key: Key('password'),
                                  hintText: "Пароль",
                                  //onSaved: (val) => setState(() => this._password = val),
                                  obscureText: true,
                                  controller: _controllerPassword,
                                  keyboardType: TextInputType.text,
                                  error: this.passwordError,
                                ),
                              ),
                              ListTile(
                                title: TextFieldWidget(
                                  key: Key('password confirm'),
                                  hintText: "Подтверждение пароля",
                                  //onSaved: (val) => setState(() => this._password = val),
                                  obscureText: true,
                                  controller: _controllerConfirm,
                                  keyboardType: TextInputType.text,
                                  error: passwordError,
                                ),
                              ),
                            ],
                          ),

                        ListTile(
                          title: ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(Size(10, 50)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states){
                                    if (states.contains(MaterialState.disabled))
                                      return Color(0x337952B3);
                                    return Color(0xFF7952B3);
                                  },
                                ),
                              ),
                              child:Text(
                                this.registration ? "Зарегистрироваться" : "Войти",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                              onPressed: checkAuthButton() ? () async => await authorize() : null
                          ),
                        ),
                          ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateColor.resolveWith((states) =>  Color(0xFFEDEBF0)),
                              ),
                              onPressed: () {
                                _controllerPassword.clear();
                                _controllerConfirm.clear();
                                _controllerEmail.clear();
                                _user.discharge();
                                dischargeErrors();
                                this.registration = !this.registration;
                                setState(() {});
                              },
                              child: Text(!this.registration ? "Зарегистрироваться" : "Войти",
                                  style: TextStyle(color: Color(0xFF7952B3), decoration: TextDecoration.underline)
                              ),
                            ),
                          ),
                        if (!this.registration)
                          ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateColor.resolveWith((states) =>  Color(0xFFEDEBF0)),
                              ),
                              onPressed: () => print(123),
                              child: Text("Войти позже", style: TextStyle(color: Color(0xFF7952B3), decoration: TextDecoration.underline)),
                            ),
                          ),
                        ListTile(
                          title: Container(
                            color: Color(0xFFFCFCFC),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Вход в приложение позволит покупать билеты, просматривать баланс и историю поездок",
                              style: TextStyle(
                                  color: Color(0xFFAFB8C3),
                                fontSize: 16,
                                height: 2
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkAuthButton(){
    return this.registration
        ? this._user.email != null &&
        this._user.birthDate != null &&
        this._user.name != null &&
        this._user.surname != null &&
        this._user.gender != null &&
        this._user.login != null &&
        this._controllerPassword.text != '' &&
        this._controllerConfirm.text != ''
        : this._controllerPassword.text != '' &&
        this._controllerEmail.text != '';
  }

  Future authorize() async {
    if (registration)
      if (!validate())
        print("VALIDATION ERRORS OCCURED");

    print(this.registration ? "TODO handle REGISTRATION" : "TODO handle LOGIN");
  }

  bool validate(){
    dischargeErrors();
    bool result = true;
    if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$").hasMatch(_controllerPassword.text)) {
      passwordError = "Слабый пароль";
      result = false;
    }
    if (_controllerConfirm.text != _controllerPassword.text){
      passwordError = "Пароли не совпадают";
      result = false;
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_user.email)){
      emailError = "Некорректный email";
      result = false;
    }
    if (!RegExp(r"[a-zA-Zа-яА-Я]").hasMatch(_user.name)){
      nameError = "Некорректное имя";
      result = false;
    }
    if (!RegExp(r"[a-zA-Zа-яА-Я]").hasMatch(_user.surname)){
      surnameError = "Некорректная фамилия";
      result = false;
    }
    if (!RegExp(r"[a-zA-Zа-яА-Я0-9]").hasMatch(_user.login)){
      loginError = "Некорректный логин";
      result = false;
    }
    setState(() {});
    return result;
  }

  dischargeErrors() {
    setState(() {
      passwordError = null;
      nameError = null;
      surnameError = null;
      emailError = null;
      loginError = null;
    });
  }
}