import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

abstract class LoggerInterceptor implements InterceptorContract {
  Future<RequestData> interceptRequest({required RequestData data});
  Future<ResponseData> interceptResponse({required ResponseData data});
}