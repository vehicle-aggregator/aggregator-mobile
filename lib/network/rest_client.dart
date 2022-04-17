import 'dart:async';
import 'dart:io';

import 'package:aggregator_mobile/network/session_manager.dart';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../routes.dart';
import 'endpoints.dart';


class RestClient {
  Dio _dio;

  SessionManager _sessionManager = SessionManager();

  static final RestClient _client = RestClient._internal();

  factory RestClient() => _client;

  RestClient._internal() {
    _dio = new Dio();

    _dio.options.baseUrl =
        Endpoints.server;
    //Endpoints.localhost;
    _dio.options.connectTimeout = 20000;
    _dio.options.receiveTimeout = 10000;
    _dio.transformer = FlutterTransformer();

    _dio.interceptors.add(EnvironmentManager());
    // _dio.interceptors.add(PrettyDioLogger(compact: false, maxWidth: 10000));
    _dio.interceptors.add(_sessionManager);
  }

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(String url, {Map<String, dynamic> match = const {}, Map<String, dynamic> headers = const {},}) async
  {
    try {
      final response = await _dio.get(url, queryParameters: match);
      return response.data;
    } on DioError catch (e) {
      if (e.response.statusCode == 401) {
        //await AuthModel().logout();
        navigatorKey.currentState.pushNamedAndRemoveUntil(Routes.login.toString(), (route) => false);
      }
      return throw e;
    }
  }

  // Future<dynamic> _processError(DioError error) {
  //   if (error.type == DioErrorType.RESPONSE) {
  //     Response response = error.response;
  //     int statusCode = response.statusCode;
  //
  //     // if (statusCode >= 500) throw InternalServerException(response);
  //     // if (statusCode == 401) throw UnauthorizedException(response);
  //     // if (statusCode == 403) throw AccessForbiddenException(response);
  //     // if (statusCode == 404) throw NotFoundException(response);
  //     // if (statusCode == 429) throw RateLimitException(response);
  //
  //     print('response $response');
  //     throw APIException.build(response);
  //   }
  //
  //   throw NetworkException(error);
  // }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(String url, body, {Map<String, dynamic> headers = const {}}) async
  {
    try{
      FormData fd = FormData.fromMap(body);
      final response = await _dio.post(url, data: fd);
      return response.data;
    } catch (e){
      print('ERRRRRRROOOORRRR ==> $e');
    }
  }

  // Future<Response<dynamic>> postEmpty(String url, {body, Map<String, dynamic> headers = const {}}) async {
  //   print('post $url');
  //   try {
  //     addOptionalHeaders(headers);
  //     final response = await _dio.post(url, data: body);
  //     cleanOptionalHeaders(headers);
  //     return response;
  //   } on DioError catch (e, stackTrace) {
  //     print('error $e, stackTrace $stackTrace');
  //     cleanOptionalHeaders(headers);
  //     return _processError(e);
  //   }
  // }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(url, data: body);
      return response.data;
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<dynamic> postFile(String url, File file) async {
    print('post file $url');
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Response response = await _dio.post(url, data: formData);
      return response.data;
    } catch (e) {
      throw e;
    }
  }

  delete(String url) async {
    try {
      var response = await _dio.delete(url);
      return response.data;
    } on DioError catch (e) {
      throw e;
    }
  }

  cleanSession() {
    _sessionManager.clean();
  }

  // Future<bool> download(String url, {
  //   Map<String, dynamic> match = const {},
  //   String filePath
  // }) async {
  //   try{
  //     Permission permission = Permission.storage;
  //     if (!await permission.isGranted){
  //       PermissionStatus status = await permission.request();
  //       if (status != PermissionStatus.granted){
  //         print("Permission is not granted");
  //         return false;
  //       }
  //     }
  //     await _dio.download(url, filePath, queryParameters: match);
  //     return true;
  //   }
  //   catch(e){
  //     print(e);
  //     return false;
  //   }
  // }

}

class EnvironmentManager extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    final instance = await SharedPreferences.getInstance();
    const KEY = "BASE_ENV";
    final baseUrl = instance.getString(KEY);
    options.baseUrl =
        Endpoints.server;
    //Endpoints.localhost;
    print(options.baseUrl); //baseUrl != null ? baseUrl : Endpoints.live;
  }
}