
import 'dart:async';

import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/pages/onboarding/pincode_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import '../../routes.dart';

class PinCodeScreen extends StatefulWidget {
  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

enum UiState {
  LOADING,
  ENTER,
  SETUP,
  SETUP_CONFIRM,
  ERROR_CONFIRM,
  ERROR_ENTER,
  COMPLETE,
  ENTER_SUCCESS
}

class _PinCodeScreenState extends State<PinCodeScreen>
    with WidgetsBindingObserver {
  AuthModel _auth;

  UiState _uiState;

  String pinCode;

  AppLifecycleState _lastLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() => _lastLifecycleState = state);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration.zero).then((_) async {
      _auth = Provider.of<AuthModel>(context, listen: false);

      final hasPinCode = await _auth.hasPinCode();
      final uiState = hasPinCode ? UiState.ENTER : UiState.SETUP;

      setState(() => _uiState = uiState);

    });
  }

  void onCodeFilled(code) async {
    if (_uiState == UiState.SETUP) {
      setState(() {
        pinCode = code;
        _uiState = UiState.SETUP_CONFIRM;
      });
      return;
    }
    if (_uiState == UiState.SETUP_CONFIRM) {
      if (pinCode == code) {
        await _auth.setPinCode(code);

        setState(() {
          pinCode = "";
          _uiState = UiState.COMPLETE;
        });


        navigate();
        return;
      } else {
        setState(() {
          pinCode = "";
          _uiState = UiState.ERROR_CONFIRM;
        });

        await Future.delayed(Duration(seconds: 2));

        setState(() {
          pinCode = "";
          _uiState = UiState.SETUP;
        });

        return;
      }
    }
    if (_uiState == UiState.ENTER) {
      var correct = await _auth.confirmPinCode(code);
      if (correct) {
        setState(() {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          _uiState = UiState.ENTER_SUCCESS;
        });
        await Future.delayed(Duration(seconds: 2)).then((v) => navigate());
        return;
      } else {
        setState(() {
          pinCode = "";
          _uiState = UiState.ERROR_ENTER;
        });

        await Future.delayed(Duration(seconds: 2));

        setState(() {
          pinCode = "";
          _uiState = UiState.ENTER;
        });

        return;
      }
    }
  }

  // Future setBiometricsOn(LocalAuthentication localAuth) async {
  //   print('setBiometricsOn');
  //   try {
  //     var result = await localAuth.authenticateWithBiometrics(
  //         stickyAuth: true, localizedReason: "Authentication");
  //
  //     print('setBiometricsOn.result $result');
  //     if (result == false) {
  //       await Future.delayed(Duration(seconds: 1));
  //     }
  //
  //     if (result) await _auth.setBiometricsOn();
  //
  //     final illegalStates = (_lastLifecycleState != AppLifecycleState.paused &&
  //         _lastLifecycleState != AppLifecycleState.inactive);
  //     if (result == true || illegalStates) {
  //       navigate();
  //     }
  //   } catch (e) {
  //     print('setBiometricsOn.error $e');
  //     navigate();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (_uiState == UiState.ENTER_SUCCESS) {
      return Scaffold(
          body: SafeArea(
            child: Center(child: CircularProgressIndicator( color: Theme.of(context).primaryColor,)),
          )
      );
    }

    if (_uiState == UiState.LOADING || _uiState == UiState.COMPLETE) {
      return Scaffold(
          body: SafeArea(
            child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
          ));
    }

    var subText = getSubTest();
    var title = getTitle();
    var alert = getAlert();
    var enabled = !alert;
    var headerColor = alert ? Colors.redAccent : Colors.black;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: headerColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:
                        Text(subText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 16,
                                height: 24 / 16,
                                fontWeight: FontWeight.normal
                            )
                        )
                      ),
                    ]),
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: PinCode(
                      key: UniqueKey(),
                      onEnter: onCodeFilled,
                      enabled: enabled
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  String getSubTest() {
    if (_uiState == UiState.SETUP)
      return "Придумайте пин-код, чтобы не проходить\nавторизацию при каждом входе в приложение";
    return "";
  }

  String getTitle() {
    if (_uiState == UiState.SETUP) return "Придумайте пин-код";
    if (_uiState == UiState.SETUP_CONFIRM) return "Подтвердите пин-код";
    if (_uiState == UiState.ENTER) return "Введите пин-код";
    if (_uiState == UiState.ERROR_CONFIRM) return "Пин-коды не совпадают";
    if (_uiState == UiState.ERROR_ENTER) return "Неверный пин-код";

    return "";
  }

  void navigate() async {

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    var route = _uiState == UiState.ENTER_SUCCESS
        ? Routes.home
        : Routes.home;

    await Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  getAlert() {
    print("GET ALERT");
    if (_uiState == UiState.ERROR_CONFIRM) return true;
    if (_uiState == UiState.ERROR_ENTER) return true;

    return false;
  }
}