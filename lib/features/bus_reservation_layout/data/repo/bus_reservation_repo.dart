import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/bus_reservation_layout/data/models/ReservationResponse.dart';

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
  Future<ReservationResponse> addReservation ({
    required List<num> seatIdsOneTrip,
     List<int>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID
  })async {
    var response = await apiConsumer.post(
        EndPoints.reservation,
        body: jsonEncode({
          "SeatIdsOneTrip":seatIdsOneTrip,
          "SeatIdsRoundTrip":seatIdsRoundTrip,
          "CustId":custId,
          "OneTripID":oneTripID,
          "RoundTripID":roundTripID
        })
    );
    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponse reservationResponse = ReservationResponse.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponse;
  }
}