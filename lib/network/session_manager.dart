import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager extends Interceptor {
  String token;
  static const String KEY = 'token';

  @override
  Future onRequest(RequestOptions options) async {
    final instance = await SharedPreferences.getInstance();
    if (token == null) token = instance.getString(KEY);
    if (token != null) options.headers['token'] = token;
  }

  @override
  Future onResponse(Response response) async {
    if (response.headers['token'] != null) {
      token = response.headers['token'][0];
      (await SharedPreferences.getInstance()).setString(KEY, token);
    }
  }

  @override
  Future onError(DioError err) async {
    print('onError $err');

    if (err.response?.statusCode == 401) {
      token = '';
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(KEY, null);
    }
  }

  void clean() {}
}