import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:login_page/env.dart';

class LoginRepository {
  InterceptedClient client;

  LoginRepository(this.client);
  Future<Map<String, dynamic>> login(
      {required String username, required String password}) async {
    Map<String, dynamic> apiResponse;
    Map<String, dynamic> params = {"username": username, "password": password};
    try {
      final response =
          await client.post('${Env.baseUrl}/login'.toUri(), params: params);
      if (response.statusCode == 200) {
        apiResponse = jsonDecode(response.body);
      } else {
        return Future.error(
          'Error while fetching.',
          StackTrace.fromString(response.body),
        );
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on Exception catch (error) {
      log(error.toString());
      return Future.error('Unexpected error 😢');
    }

    return apiResponse;
  }
}

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
