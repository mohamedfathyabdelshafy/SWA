import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/sign_in/data/models/user_model.dart';
import 'package:swa/features/sign_in/data/models/user_response_model.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';

abstract class LoginRemoteDataSource {
  Future<UserResponseModel> userLogin(UserLoginParams params);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiConsumer apiConsumer;
  LoginRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UserResponseModel> userLogin(UserLoginParams params) async {
    final response = await apiConsumer.post(
      '${EndPoints.login}?username=${params.username}&password=${params.password}&type=Customer',
    );

    print(await response.body);

    var res = UserResponseModel.fromJson(json.decode(response.body.toString()));
    if (res.status == 'success') {
      updatefcm(res.user!.customerId!);
    }
    return res;
  }

  Future updatefcm(int id) async {
    String fcmtoken = await FirebaseMessaging.instance.getToken() ?? " ";

    final response = await apiConsumer.get(
      '${EndPoints.baseUrl}Customer/UpdateFCM?CustomerID=$id&token=$fcmtoken',
    );
    log(fcmtoken);

    log(await response.body);
  }
}
