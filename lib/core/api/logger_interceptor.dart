import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

abstract class LoggerInterceptor implements InterceptorContract {
  Future<BaseRequest> interceptRequest({required BaseRequest request});
  Future<BaseResponse> interceptResponse({required BaseResponse response});
}
