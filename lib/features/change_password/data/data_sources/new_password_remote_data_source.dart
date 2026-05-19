import 'dart:convert';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/forgot_password/data/models/message_response_model.dart';
import 'package:swa/features/change_password/domain/use_cases/new_password.dart';

abstract class NewPasswordRemoteDataSource{
  Future<MessageResponseModel> newPassword(NewPasswordParams params);
}

class NewPasswordRemoteDataSourceImpl implements NewPasswordRemoteDataSource {
  final ApiConsumer apiConsumer;
  NewPasswordRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<MessageResponseModel> newPassword(NewPasswordParams params) async{
    final response = await apiConsumer.get(
      '${EndPoints.changePassword}?oldPassword=${params.oldPass}&newPassword=${params.newPass}&userId=${params.userId}'
    );
    return MessageResponseModel.fromJson(json.decode(response.body.toString()));
  }

}