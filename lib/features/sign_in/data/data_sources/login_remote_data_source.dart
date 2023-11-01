import 'dart:convert';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/sign_in/data/models/user_model.dart';
import 'package:swa/features/sign_in/data/models/user_response_model.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';

abstract class LoginRemoteDataSource{
  Future<UserResponseModel> userLogin(UserLoginParams params);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiConsumer apiConsumer;
  LoginRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UserResponseModel> userLogin(UserLoginParams params) async{
    final response = await apiConsumer.post(
      EndPoints.login,
      body: <String, String>{
        "username": params.username,
        "password": params.password,
        "type": "Customer"
      },
    );
    return UserResponseModel.fromJson(json.decode(response.body.toString()).first);
  }

}