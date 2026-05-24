import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/forgot_password/data/models/message_response_model.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';
import 'package:swa/features/forgot_password/domain/use_cases/submit_password.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<MessageResponseModel> forgotPassword(ForgotPasswordParams params);
  Future<MessageResponseModel> submitPassword(SubmitPasswordParams params);
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  final ApiConsumer apiConsumer;
  ForgotPasswordRemoteDataSourceImpl({required this.apiConsumer});

  static const Duration _requestTimeout = Duration(seconds: 20);

  @override
  Future<MessageResponseModel> forgotPassword(
      ForgotPasswordParams params) async {
    final resetPasswordUri = Uri.parse(EndPoints.resetPassword).replace(
      queryParameters: {'email': params.email.trim()},
    );
    final response = await apiConsumer
        .get(resetPasswordUri.toString())
        .timeout(_requestTimeout);
    return MessageResponseModel.fromJson(json.decode(response.body.toString()));
  }

  @override
  Future<MessageResponseModel> submitPassword(
      SubmitPasswordParams params) async {
    final submitResetPasswordUri =
        Uri.parse(EndPoints.submitResetPassword).replace(
      queryParameters: {
        'userId': params.userId,
        'code': params.code,
        'newPassword': params.newPassword,
      },
    );
    final response = await apiConsumer
        .post(submitResetPasswordUri.toString())
        .timeout(_requestTimeout);

    log("forgot password" + response.body.toString());
    return MessageResponseModel.fromJson(json.decode(response.body.toString()));
  }
}
