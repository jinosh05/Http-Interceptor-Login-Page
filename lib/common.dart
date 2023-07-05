import 'dart:developer';

import 'package:http_interceptor/http_interceptor.dart';

class LoggerInterceptor extends InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    log('----- Request -----');
    log(data.toString());
    log(data.headers.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    log('----- Response -----');
    log('Code: ${data.statusCode}');
    log(data.toString());
    return data;
  }
}
