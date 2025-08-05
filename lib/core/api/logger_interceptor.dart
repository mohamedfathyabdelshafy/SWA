import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';

abstract class LoggerInterceptor implements InterceptorContract {
  // @override
  // Future<BaseRequest> interceptRequest({required BaseRequest request});
  // @override
  // Future<BaseResponse> interceptResponse({required BaseResponse response});
}
