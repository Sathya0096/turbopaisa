import 'dart:convert';

import 'package:dio/dio.dart';

class StringResponseConverter extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // try {
    //   response.data = json.decode(response.data);
    // } catch (e) {
    //   print(e);
    // }
    super.onResponse(response, handler);
  }
}
