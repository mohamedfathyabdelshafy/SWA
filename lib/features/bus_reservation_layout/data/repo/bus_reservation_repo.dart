import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Reservation_Response_model.dart';

import '../../../../core/api/api_consumer.dart';
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
  Future<ReservationResponseModel> addReservation ({
    required List<num> seatIdsOneTrip,
     List<int>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID,
    required int paymentMethodID,
    required int paymentTypeID,
    double? amount,
    double? amount2,
    double? amount3,
    String? cardNumber,
    String? cardExpiryYear,
    String? cardExpiryMonth,
    String? cvv,
    String? mobile

  })async {
    var response = await apiConsumer.post(
        EndPoints.reservation,
      body: jsonEncode({
        "SeatIdsOneTrip": seatIdsOneTrip,
        "SeatIdsRoundTrip": seatIdsRoundTrip,
        "CustId": custId,
        "OneTripID": oneTripID,
        "RoundTripID": roundTripID,
        "PaymentMethodID": paymentMethodID,
        "PaymentTypeID": paymentTypeID,
        "cardPaymentModel": {
          "amount": amount,
          "cardExpiryMonth": cardExpiryMonth,
          "cardExpiryYear": cardExpiryYear,
          "cardNumber": cardNumber,
          "customerId": custId, // Assuming you want to use the same customerId for cardPaymentModel
          "cvv": cvv,
        },
        "EwalletModel": {
          "customerId": custId, // Assuming you want to use the same customerId for EwalletModel
          "amount": amount2,
          "mobile": mobile,
        },
        "RefNoModel": {
          "amount": amount3,
          "customerId": custId, // Assuming you want to use the same customerId for RefNoModel
        },
      }),
    );
    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseModel reservationResponseModel = ReservationResponseModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseModel;
  }



}