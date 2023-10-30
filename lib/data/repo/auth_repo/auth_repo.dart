import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:swa/core/utilts/strings.dart';
import 'package:http/http.dart';
import 'package:swa/data/model/UserResponse.dart';

abstract class ApiManager {

  static Future<UserResponse> login(String email,String password)async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile
        || connectivityResult == ConnectivityResult.wifi) {
      Uri url = Uri.parse("http://api.swabus.com/api/Accounts/Login?username=$email&password=$password&type=Customer");

      Response response = await post(url,headers: {
        "APIKey":"546548dwfdfsd3f4sdfhgat52"
      },);
      UserResponse userResponse = UserResponse.fromJson(
          jsonDecode(response.body,));
      if (userResponse.status == "success") {
        log("${userResponse.status}",name: "success");
        return userResponse;
      } else {
        log("${userResponse.status}",name: "faild");
        return UserResponse(massage:"invalid pass or email");
      }
    } else {
      log("noInternet",name: "faild");
      return UserResponse(massage: Constants.noInternet);
    }
  }
}