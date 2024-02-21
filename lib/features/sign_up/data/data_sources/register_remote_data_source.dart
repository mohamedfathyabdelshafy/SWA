import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/sign_up/data/models/message_response_model.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';

abstract class RegisterRemoteDataSource {
  Future<MessageResponseModel> registerUser(UserRegisterParams params);
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final ApiConsumer apiConsumer;
  RegisterRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<MessageResponseModel> registerUser(UserRegisterParams params) async {
    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52'
    };
    var request = http.Request(
        'POST', Uri.parse('${EndPoints.baseUrl}/Customer/AddCustomer'));
    request.body = json.encode({
      "Name": params.name,
      "Mobile": params.mobile,
      "Email": params.email,
      "Password": params.password,
      "UserType": params.userType,
      "CountryID": params.countryId,
      "CityID": params.cityId,
    });
    request.headers.addAll(headers);

    print(' body ' + request.body);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(await response.stream.bytesToString());

      print(jsonResponse);
      return MessageResponseModel.fromJson(jsonResponse);
    } else {
      print(response.reasonPhrase);

      return const MessageResponseModel(
          balance: '', massage: 222, obj: '', status: 'error', object: '');
    }
  }
}
