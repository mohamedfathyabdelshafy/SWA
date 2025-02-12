import 'dart:convert';
import 'dart:developer';

import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/TimesTripsResponsedart.dart';

class TimesTripsRepo {
  final ApiConsumer apiConsumer;
  TimesTripsRepo({required this.apiConsumer});

  Future<TimesTripsResponse?> getTimesTrip(
      {required String TripType,
      required String FromStationID,
      required String ToStationID,
      required String DateGo,
      required String DateBack}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer.post(EndPoints.timesTrips,
        body: jsonEncode({
          "TripType": TripType,
          "FromStationIDGo": FromStationID,
          "ToStationIDGo": ToStationID,
          "FromStationIDBack": ToStationID,
          "ToStationIDBack": FromStationID,
          "DateGo": DateGo,
          "DateTypeID": UmraDetails.dateTypeID,
          "toCurrency": Routes.curruncy,
          "DateBack": DateBack,
          "countryID": countryid
        }));
    var decodedResponse = json.decode(response.body);
    print("request ${response.request.body}");

    log("responsedd $decodedResponse");

    if (decodedResponse['status'] != "failed") {
      TimesTripsResponse timesTripsResponse =
          TimesTripsResponse.fromJson(decodedResponse);
      return timesTripsResponse;
    } else {
      return TimesTripsResponse(
          failureMessage: decodedResponse['message'], status: "failed");
    }
  }
}
