import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:swa/core/utils/app_strings.dart';

class AppInterceptors extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    try {
      request.headers[AppStrings.contentType] = AppStrings.applicationJson;
      request.headers[AppStrings.charset] = AppStrings.utf;
    } catch (e) {
      debugPrint(e.toString());
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    try {
      debugPrint(
          'RESPONSE[${response.statusCode}] => PATH: ${response.request!.url}');
    } catch (e) {
      debugPrint(e.toString());
    }
    return response;
  }
}
