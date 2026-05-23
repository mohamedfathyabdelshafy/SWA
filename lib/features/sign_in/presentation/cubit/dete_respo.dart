import 'dart:convert';

import 'package:swa/core/utils/language.dart';
import 'package:swa/features/sign_in/data/models/user_response_model.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';

import 'package:http/http.dart' as http;

class Userdeleterespo {
  Future<UserResponseModel> deleteuserfun(int id) async {
    var headers = {
      'APIKey': '546548dwfdfsd3f4sdfhgat52',
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };
    var request = http.Request('POST',
        Uri.parse('http://API.SWABUS.COM/APi/Customer/Delete?id=${id}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(await response.stream.bytesToString());

      print(jsonResponse);
      return UserResponseModel.fromJson(jsonResponse);
    } else {
      print(response.reasonPhrase);

      return UserResponseModel(
          balance: '',
          obj: '',
          status: 'error',
          object: '',
          massage: 'error',
          user: User());
    }
  }
}
