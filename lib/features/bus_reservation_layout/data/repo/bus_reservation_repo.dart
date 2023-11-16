import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/end_points.dart';

import '../../../../core/api/api_consumer.dart';
import '../models/BusSeatsModel.dart';

class BusLayoutRepo {
  final ApiConsumer apiConsumer;
  BusLayoutRepo({required this.apiConsumer});
  Future<BusSeatsModel> getBusSeatsData(
  ) async {
    var response = await apiConsumer.get(
    "http://testapi.swabus.com/api/Trip/GetSingleTripDetails?tripId=106"
    );

    log('ReservationData response ' + response.body);

    var decodedResponse = json.decode(response.body);
    BusSeatsModel busSeatsModel = BusSeatsModel.fromJson(decodedResponse);
    return busSeatsModel;
  }
}