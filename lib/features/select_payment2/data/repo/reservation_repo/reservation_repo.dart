import 'dart:convert';
import 'dart:developer';

import 'package:swa/features/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/features/select_payment2/data/models/Reservation_Response_Electronic_model.dart';

import '../../../../../core/api/api_consumer.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../payment/select_payment/data/models/payment_message_response_model.dart';
import '../../models/Reservation_response_MyWallet_model.dart';

class ReservationRepo{
  final ApiConsumer apiConsumer;
  ReservationRepo({required this.apiConsumer});

  Future<ReservationResponseMyWalletModel?> addReservationMyWallet ({
    required List<dynamic> seatIdsOneTrip,
    List<dynamic>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID,
    required int paymentTypeID,
    required String amount,
    required String tripDateGo,
    String? tripDateBack,
    required String fromStationID,
    required String toStationId
  })async {
    var response = await apiConsumer.post(
      EndPoints.reservation,
      body: jsonEncode({
        "SeatIdsOneTrip": seatIdsOneTrip,
        "SeatIdsRoundTrip": seatIdsRoundTrip,
        "CustId": custId,
        "OneTripID": oneTripID,
        "RoundTripID": roundTripID,
        "PaymentTypeID": paymentTypeID,
        "Amount":amount,
        "TripDateGo":tripDateGo,
        "TripDateBack":tripDateBack,
        "FromStationID":fromStationID,
        "ToStationID":toStationId,

      }),
    );
    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseMyWalletModel reservationResponseMyWalletModel = ReservationResponseMyWalletModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future<ReservationResponseElectronicModel?> addReservationElectronicWallet ({
    required List<dynamic> seatIdsOneTrip,
    List<dynamic>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID,
    int? paymentMethodID,
    required int paymentTypeID,
    required String amount,
    String? mobile,
    required String tripDateGo,
    String? tripDateBack,
    required String fromStationID,
    required String toStationId
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
        "TripDateGo":tripDateGo,
        "TripDateBack":tripDateBack,
        "FromStationID":fromStationID,
        "ToStationID":toStationId,
        "Amount":amount,

        "EwalletModel": {
          "customerId": custId, // Assuming you want to use the same customerId for EwalletModel
          "amount": amount,
          "mobile": mobile,
        },

      }),
    );
    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseElectronicModel reservationResponseElectronicModel = ReservationResponseElectronicModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseElectronicModel;
  }


  Future<ReservationResponseElectronicModel?> addReservationFawry({
    required List<dynamic> seatIdsOneTrip,
    List<dynamic>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID,
    int? paymentMethodID,
    required int paymentTypeID,
    required String amount,
    required String tripDateGo,
    String? tripDateBack,
    required String fromStationID,
    required String toStationId
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
        "TripDateGo":tripDateGo,
        "TripDateBack":tripDateBack,
        "FromStationID":fromStationID,
        "ToStationID":toStationId,
        "Amount":amount,
        "RefNoModel":{
          "CustomerId":custId,
          "Amount":amount
        }

      }),
    );
    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseElectronicModel reservationResponseElectronicModel = ReservationResponseElectronicModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseElectronicModel;
  }

  Future<ReservationResponseCreditCard?> addReservationCreditCard({
    required List<dynamic> seatIdsOneTrip,
    List<dynamic>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID,
    int? paymentMethodID,
    required int paymentTypeID,
    required String amount,
    required String tripDateGo,
    String? tripDateBack,
    required String fromStationID,
    required String toStationId,
    required String cardNumber,
    required String cardExpiryYear,
    required String cvv,
    required String cardExpiryMonth,

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
        "TripDateGo":tripDateGo,
        "TripDateBack":tripDateBack,
        "FromStationID":fromStationID,
        "ToStationID":toStationId,
        "Amount":amount,
        "cardPaymentModel":{
          "CustomerId":custId,
          "amount":amount,
          "cardNumber":cardNumber,
          "cardExpiryYear":cardExpiryYear,
          "cardExpiryMonth":cardExpiryMonth,
          "cvv":cvv
        },

      }),
    );
    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseCreditCard reservationResponseCreditCard = ReservationResponseCreditCard.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseCreditCard;
  }


}