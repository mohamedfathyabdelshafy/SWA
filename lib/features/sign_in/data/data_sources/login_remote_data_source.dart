import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:huawei_push/huawei_push.dart';
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

  Future<void> updatefcm(int id) async {
    String pushToken = '';
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    final isHuawei = deviceInfo.manufacturer.toLowerCase().contains('huawei');

    if (isHuawei) {
      try {
        // Enable auto-init (if not already done)
        await Push.setAutoInitEnabled(true);

        // Token will be received through this stream
        Completer<String> tokenCompleter = Completer<String>();

        StreamSubscription? sub;
        sub = Push.getTokenStream.listen(
          (event) {
            if (!tokenCompleter.isCompleted) {
              tokenCompleter.complete(event);
            }
            sub?.cancel(); // Cancel after getting token
          },
          onError: (e) {
            if (!tokenCompleter.isCompleted) {
              tokenCompleter.complete('');
            }
            sub?.cancel();
          },
        );

        // Trigger token generation
        Push.getToken("");

        // Wait for token or timeout
        pushToken = await tokenCompleter.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            return '';
          },
        );
      } catch (e) {
        pushToken = '';
      }
    } else {
      // Firebase fallback
      pushToken = await FirebaseMessaging.instance.getToken() ?? '';
    }

    if (pushToken.isEmpty) {
      log("No push token available.");
      return;
    }

    log("Sending token: $pushToken");

    final response = await apiConsumer.get(
      '${EndPoints.baseUrl}Customer/UpdateFCM?CustomerID=$id&token=$pushToken&isHuawei=$isHuawei',
    );

    log("Tik Tim update FCM res: ${await response.body}");
  }
}
