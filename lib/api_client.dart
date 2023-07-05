import 'dart:developer';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';

class LoginInterceptor extends InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final Map<String, String> headers = Map.from(data.headers);
    headers[HttpHeaders.contentTypeHeader] = 'application/json';
    final Map<String, dynamic> param = data.params;

    param.addAll({
      ///
      ///  Other parameters have to be added here
      ///
    });
    RequestData(
      method: data.method,
      baseUrl: data.baseUrl,
      headers: headers,
      body: data.body,
      encoding: data.encoding,
      params: param,
    );
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 2;

  @override
  bool shouldAttemptRetryOnException(Exception reason) {
    log(reason.toString());
    return false;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      log('Retrying request...');
      return true;
    }
    return false;
  }
}
