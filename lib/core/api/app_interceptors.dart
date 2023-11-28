import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:swa/core/utils/app_strings.dart';


class AppInterceptors extends InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async{
    try{
      data.headers[AppStrings.contentType] = AppStrings.applicationJson;
      data.headers[AppStrings.charset] = AppStrings.utf;
    }catch(e){
      debugPrint(e.toString());
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async{
    try{
      debugPrint('RESPONSE[${data.statusCode}] => PATH: ${data.request!.url}');
    }catch (e) {
      debugPrint(e.toString());
    }
    return data;
  }


}