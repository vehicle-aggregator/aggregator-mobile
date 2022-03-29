

import 'package:aggregator_mobile/models/user.dart';
import 'package:aggregator_mobile/network/endpoints.dart';
import 'package:aggregator_mobile/network/rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel {
  User user;

  RestClient _client = RestClient();

  Future<User> getUserProfile(int id) async {
    var json = await _client.get("${Endpoints.me}?uid=$id");
    return setUser(User.fromJson(json));
  }

  Future<User> login({
    @required String email,
    @required String password,
    BuildContext context
  }) async {
    final body = {'email': email, 'password': password};
    final json = await _client.post(Endpoints.login, body);
    return setUser(User.fromJson(json));
  }

  Future<User> setUser(User user) async {
    this.user = user;
    var instance = await SharedPreferences.getInstance();
    await instance.setInt("ID", user.id);
    return user;
  }

  // Future<void> forgotPassword({
  //   @required String email,
  // }) async {
  //   final body = {'email': email};
  //   await _client.post(Endpoints.forgotPassword, body, headers: HttpConstants.recaptchaHeader);
  // }

  Future<void> logout() async {
    user = null;
    try {
      final instance = await SharedPreferences.getInstance();
      await instance.remove("ID");
      await instance.setBool("PIN_CODE_ENABLED", false);
      await instance.setBool("PIN_CODE_TOUCH_ENABLED", false);
      //await _client.post(Endpoints.logout, {});
    } catch (e) {} finally {
      await _client.cleanSession();
    }
  }

  hasPinCode() async {
    var instance = await SharedPreferences.getInstance();
    var pinCodeEnabled = instance.getBool("PIN_CODE_ENABLED");
    return pinCodeEnabled == null ? false : pinCodeEnabled;
  }

  confirmPinCode(code) async {
    var instance = await SharedPreferences.getInstance();
    var pinCode = instance.getString("PIN_CODE");
    return pinCode == code;
  }

  setPinCode(code) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString("PIN_CODE", code);
    await instance.setBool("PIN_CODE_ENABLED", true);
  }
}