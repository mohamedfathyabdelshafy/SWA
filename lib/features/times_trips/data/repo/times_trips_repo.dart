import 'dart:convert';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/TimesTripsResponsedart.dart';

class TimesTripsRepo {
  final ApiConsumer apiConsumer;
  TimesTripsRepo({required this.apiConsumer});

  Future<TimesTripsResponse> getTimesTrip ({
    required String TripType,
    required String FromStationID,
    required String ToStationID,
    required String DateGo,
    required String DateBack
})async {
    var response = await apiConsumer.post(
        EndPoints.timesTrips,
        body: jsonEncode({
          "TripType":TripType,
          "FromStationID":FromStationID,
          "ToStationID":ToStationID,
          "DateGo":DateGo,
          "DateBack":DateBack
        })
    );
    var decodedResponse = json.decode(response.body);
    TimesTripsResponse timesTripsResponse = TimesTripsResponse.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return timesTripsResponse;
  }

}