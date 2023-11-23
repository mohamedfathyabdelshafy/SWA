import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Reservation_Response_fawry_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../payment/select_payment/data/models/payment_message_response_model.dart';
import '../models/BusSeatsModel.dart';
import '../models/reservation_request_model.dart';

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