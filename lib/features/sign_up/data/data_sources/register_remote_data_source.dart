import 'dart:convert';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/sign_in/data/models/user_model.dart';
import 'package:swa/features/sign_in/data/models/user_response_model.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';
import 'package:swa/features/sign_up/data/models/message_response_model.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';

abstract class RegisterRemoteDataSource{
  Future<MessageResponseModel> registerUser(UserRegisterParams params);
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final ApiConsumer apiConsumer;
  RegisterRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<MessageResponseModel> registerUser(UserRegisterParams params) async{
    final response = await apiConsumer.post(
      EndPoints.register,
      body: {
        "Name": params.name,
        "Mobile": params.mobile,
        "Email": params.email,
        "Password": params.password,
        "UserType": params.userType
      }
    );
    return MessageResponseModel.fromJson(json.decode(response.body.toString()));
  }

}