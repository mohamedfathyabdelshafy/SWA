import 'dart:convert';
import 'dart:developer';

import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/times_trips/data/models/recommended_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/TimesTripsResponsedart.dart';
import '../models/companies_model.dart';

class TimesTripsRepo {
  final ApiConsumer apiConsumer;
  TimesTripsRepo({required this.apiConsumer});

  Future<TimesTripsResponse?> getTimesTrip(
      {required String TripType,
      required String FromStationID,
      required String ToStationID,
      required String DateGo,
      required String DateBack,
      int? recommendeID,
      int? companyID,
      String? startTime,
      String? endTime}) async {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        3;
    var response = await apiConsumer.post(
      EndPoints.timesTrips,
      body: jsonEncode(
        {
          "TripType": TripType,
          "FromStationIDGo": FromStationID,
          "ToStationIDGo": ToStationID,
          "FromStationIDBack": ToStationID,
          "ToStationIDBack": FromStationID,
          "DateGo": DateGo,
          "DateTypeID": UmraDetails.dateTypeID,
          "toCurrency": Routes.curruncy,
          "DateBack": DateBack,
          "countryID": countryid,
          "RecommendeID": recommendeID,
          "CompanyID": companyID,
          "StartTime": startTime,
          "EndTime": endTime,
        },
      ),
    );
    var decodedResponse = json.decode(response.body);
    print("request ${response.request.body}");

    log("responsedd ${jsonEncode(decodedResponse)}");

    if (decodedResponse['status'] != "failed") {
      TimesTripsResponse timesTripsResponse =
          TimesTripsResponse.fromJson(decodedResponse);
      return timesTripsResponse;
    } else {
      return TimesTripsResponse(
          failureMessage: decodedResponse['message'], status: "failed");
    }
  }

  Future<CompaiesModel?> getCompaniesTrip() async {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        3;
    var response = await apiConsumer.get(
      EndPoints.getCompanyList + "?countryID=$countryid",
      // queryParameters: {
      //   "countryID": jsonEncode(countryid),
      // },
    );
    var decodedResponse = json.decode(response.body);
    print("request ${response.request.body}");

    log("responsedd $decodedResponse");

    if (decodedResponse['status'] != "failed") {
      CompaiesModel timesTripsResponse =
          CompaiesModel.fromJson(decodedResponse);
      return timesTripsResponse;
    } else {
      return CompaiesModel(
          failureMessage: decodedResponse['message'], status: "failed");
    }
  }

  Future<RecommendedModel?> getRecommendedTrip() async {
    var response = await apiConsumer.get(
      EndPoints.getRecommendedList,
      // queryParameters: {
      //   "countryID": jsonEncode(countryid),
      // },
    );
    var decodedResponse = json.decode(response.body);

    log(" response Recommended ${jsonEncode(decodedResponse)}");

    if (decodedResponse['status'] != "failed") {
      RecommendedModel timesTripsResponse =
          RecommendedModel.fromJson(decodedResponse);
      return timesTripsResponse;
    } else {
      return RecommendedModel(
          failureMessage: decodedResponse['message'], status: "failed");
    }
  }
}
