import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';

import '../model/change_password_response.dart';

class ChangePasswordRepo {
  final ApiConsumer apiConsumer;
  ChangePasswordRepo(this.apiConsumer);

  Future<ChangePasswordResponse?> changePassword(
      {required String userId,
      required String oldPass,
      required String newPass}) async {
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}Accounts/ChangePassword?userId=$userId&oldPassword=$oldPass&newPassword=$newPass");
    log('changePass ' + response.body);

    var decode = jsonDecode(response.body);
    ChangePasswordResponse changePasswordResponse =
        ChangePasswordResponse.fromJson(decode);
    return changePasswordResponse;
  }
}
