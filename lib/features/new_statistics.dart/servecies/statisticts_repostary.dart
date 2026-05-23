import 'dart:convert';
import 'dart:developer';

import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/new_statistics.dart/model/All_statics_model.dart';
import 'package:swa/features/new_statistics.dart/model/Reservationdetails_model.dart';
import 'package:swa/features/new_statistics.dart/model/main_statics_model.dart';
import 'package:swa/main.dart';

class StatistictsRepostary {
  final ApiConsumer apiConsumer = sl();

  Future getmaindata() async {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        3;

    final response = await apiConsumer.get(
        '${EndPoints.baseUrl}Customer/GetMainStatics?CustomerID=${Routes.customerid}&countryID=$countryid');

    log(response.body);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 'success') {
      return MainStaticsModel.fromJson(json.decode(response.body));
    } else {
      return response.body['message'];
    }
  }

  Future getallStatics() async {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        3;

    final response = await apiConsumer.get(
        '${EndPoints.baseUrl}Customer/GetALLStatics?CustomerID=${Routes.customerid}&countryID=$countryid&year=null');

    log(response.body);

    if (response.statusCode == 200) {
      return AllStaticsModel.fromJson(json.decode(response.body));
    } else {
      return response.body['message'];
    }
  }

  Future getReservationsDetails({required int reservationID}) async {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        3;

    final response = await apiConsumer.get(
        '${EndPoints.baseUrl}Partner/ReservationDetails?ReservationID=$reservationID&PageSize=10&PageNumber=1');

    log(response.body);

    if (response.statusCode == 200) {
      return ReservationDetailsModel.fromJson(json.decode(response.body));
    } else {
      return response.body['message'];
    }
  }
}
