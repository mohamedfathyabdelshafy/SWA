import 'dart:convert';
import 'dart:developer';

import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/home/data/models/Notifications_model.dart';
import 'package:swa/main.dart';

class NotifcationRespo {
  final ApiConsumer apiConsumer = sl();

  Future getNotifications() async {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        1;
    final response = await apiConsumer.get(
      '${EndPoints.baseUrl}Notification/NotificationList?CustomerID=${Routes.customerid}&countryID=$countryid&appID=${Routes.isomra ? 2 : 1}',
    );
    print(
        "Tik Tik Notification params, customerId: ${Routes.customerid} countryId: $countryid");
    log("Tik Tik Notification response: ${await response.body}");
    return NotificationModel.fromJson(json.decode(response.body.toString()));
  }

  Future deletenotification({required String id}) async {
    final response = await apiConsumer.get(
      '${EndPoints.baseUrl}Notification/Delete?CustomerID=${Routes.customerid}&notificationID=$id',
    );

    log(await response.body);

    return json.decode(response.body.toString());
  }

  Future Deleteall() async {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        1;
    final response = await apiConsumer.get(
      '${EndPoints.baseUrl}Notification/DeleteAll?CustomerID=${Routes.customerid}&countryID=$countryid',
    );

    log(await response.body);

    return json.decode(response.body.toString());
  }

  Future readNotification({int? id}) async {
    final response = await apiConsumer.get(
      '${EndPoints.baseUrl}Notification/UpdateRead?CustomerID=${Routes.customerid}&notificationID=$id',
    );

    log(await response.body);

    return json.decode(response.body.toString());
  }
}
