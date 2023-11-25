import 'dart:convert';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/forgot_password/data/models/message_response_model.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';

abstract class ForgotPasswordRemoteDataSource{
  Future<MessageResponseModel> forgotPassword(ForgotPasswordParams params);
}

class ForgotPasswordRemoteDataSourceImpl implements ForgotPasswordRemoteDataSource {
  final ApiConsumer apiConsumer;
  ForgotPasswordRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<MessageResponseModel> forgotPassword(ForgotPasswordParams params) async{
    final response = await apiConsumer.get(
      '${EndPoints.resetPassword}?email=${params.email}'
    );
    return MessageResponseModel.fromJson(json.decode(response.body.toString()));
  }

}