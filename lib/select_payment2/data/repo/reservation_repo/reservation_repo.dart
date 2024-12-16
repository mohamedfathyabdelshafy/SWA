import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Electronic_model.dart';
import 'package:swa/select_payment2/data/models/policyTicket_model.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';

import '../../../../../core/api/api_consumer.dart';
import '../../../../../core/api/end_points.dart';
import '../../models/Reservation_response_MyWallet_model.dart';

class ReservationRepo {
  final ApiConsumer apiConsumer;
  ReservationRepo({required this.apiConsumer});

  Future<ReservationResponseMyWalletModel?> addReservationMyWallet({
    required int custId,
    required int paymentTypeID,
    required String promoid,
    required List<TripReservationList> trips,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var response = await apiConsumer.post(
      EndPoints.reservation,
      body: json.encode({
        "TripReservationList": [
          {
            "SeatIds": trips[0].seatIds,
            "TripID": trips[0].tripId,
            "FromStationID": trips[0].fromStationId,
            "ToStationID": trips[0].toStationId,
            "TripDate": trips[0].tripDate.toString(),
            "Price": trips[0].price!.toStringAsFixed(2),
            "Discount": trips[0].discount,
            "LineID": trips[0].lineId,
            "ServiceTypeID": trips[0].serviceTypeId,
            "BusID": trips[0].busId
          },
          trips.length > 1
              ? {
                  "SeatIds": trips[1].seatIds,
                  "TripID": trips[1].tripId,
                  "FromStationID": trips[1].fromStationId,
                  "ToStationID": trips[1].toStationId,
                  "TripDate": trips[1].tripDate.toString(),
                  "Price": trips[1].price!.toStringAsFixed(2),
                  "Discount": trips[1].discount,
                  "LineID": trips[1].lineId,
                  "ServiceTypeID": trips[1].serviceTypeId,
                  "BusID": trips[1].busId
                }
              : []
        ],
        "CustomerID": custId,
        "CountryID": countryid,
        "PromoCodeID": promoid,
        "PaymentMethodID": null,
        "PaymentTypeID": paymentTypeID,
      }),
    );
    log('body ' + response.request.body);

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseMyWalletModel reservationResponseMyWalletModel =
        ReservationResponseMyWalletModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future<ReservationResponseElectronicModel?> addReservationElectronicWallet({
    required int custId,
    int? paymentMethodID,
    required int paymentTypeID,
    String? mobile,
    required String promoid,
    required List<TripReservationList> trips,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer.post(
      EndPoints.reservation,
      body: jsonEncode({
        "TripReservationList": [
          {
            "SeatIds": trips[0].seatIds,
            "TripID": trips[0].tripId,
            "FromStationID": trips[0].fromStationId,
            "ToStationID": trips[0].toStationId,
            "TripDate": trips[0].tripDate.toString(),
            "Price": trips[0].price!.toStringAsFixed(2).toString(),
            "Discount": trips[0].discount,
            "LineID": trips[0].lineId,
            "ServiceTypeID": trips[0].serviceTypeId,
            "BusID": trips[0].busId
          },
          trips.length > 1
              ? {
                  "SeatIds": trips[1].seatIds,
                  "TripID": trips[1].tripId,
                  "FromStationID": trips[1].fromStationId,
                  "ToStationID": trips[1].toStationId,
                  "TripDate": trips[1].tripDate.toString(),
                  "Price": trips[1].price!.toStringAsFixed(2).toString(),
                  "Discount": trips[1].discount,
                  "LineID": trips[1].lineId,
                  "ServiceTypeID": trips[1].serviceTypeId,
                  "BusID": trips[1].busId
                }
              : []
        ],
        "CustomerID": custId,
        "CountryID": countryid,
        "PromoCodeID": promoid,
        "PaymentTypeID": paymentTypeID,
        "PaymentMethodID": paymentMethodID,
        "EwalletModel": {
          "customerId": custId,
          "amount": trips.length > 1
              ? (trips[0].price! + trips[1].price!).toStringAsFixed(2)
              : trips[0].price!.toStringAsFixed(2),
          "mobile": mobile,
        },
      }),
    );

    log('ReservationResponse ' + response.body);

    log('body ' + response.request.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseElectronicModel reservationResponseElectronicModel =
        ReservationResponseElectronicModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseElectronicModel;
  }

  Future<ReservationResponseElectronicModel?> chargefawrymeth({
    required int custId,
    required String amount,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final msg = jsonEncode(
        {"CustomerId": custId, "Amount": amount, "countryID": countryid});

    print(msg);
    var response = await apiConsumer.post(
      EndPoints.fawryPaymentMethod,
      body: msg,
    );

    print(" Body " + response.request.body);

    log('fawry Response ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseElectronicModel reservationResponseElectronicModel =
        ReservationResponseElectronicModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseElectronicModel;
  }

  Future getpolicy() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer
        .get("${EndPoints.baseUrl}Settings/PloicyTrip?countryID=$countryid");

    log("policy" + res.body);
    var decode = json.decode(res.body);
    Policyticketmodel linesModel = Policyticketmodel.fromJson(decode);
    return linesModel;
  }

  Future<ReservationResponseElectronicModel?> addReservationFawry({
    required int custId,
    int? paymentMethodID,
    required int paymentTypeID,
    required String promoid,
    required List<TripReservationList> trips,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer.post(
      EndPoints.reservation,
      body: jsonEncode({
        "TripReservationList": [
          {
            "SeatIds": trips[0].seatIds,
            "TripID": trips[0].tripId,
            "FromStationID": trips[0].fromStationId,
            "ToStationID": trips[0].toStationId,
            "TripDate": trips[0].tripDate.toString(),
            "Price": trips[0].price!.toStringAsFixed(2).toString(),
            "Discount": trips[0].discount,
            "LineID": trips[0].lineId,
            "ServiceTypeID": trips[0].serviceTypeId,
            "BusID": trips[0].busId
          },
          trips.length > 1
              ? {
                  "SeatIds": trips[1].seatIds,
                  "TripID": trips[1].tripId,
                  "FromStationID": trips[1].fromStationId,
                  "ToStationID": trips[1].toStationId,
                  "TripDate": trips[1].tripDate.toString(),
                  "Price": trips[1].price!.toStringAsFixed(2).toString(),
                  "Discount": trips[1].discount,
                  "LineID": trips[1].lineId,
                  "ServiceTypeID": trips[1].serviceTypeId,
                  "BusID": trips[1].busId
                }
              : []
        ],
        "CustomerID": custId,
        "CountryID": countryid,
        "PromoCodeID": promoid,
        "PaymentTypeID": paymentTypeID,
        "PaymentMethodID": paymentMethodID,
        "RefNoModel": {
          "CustomerId": custId,
          "Amount": trips.length > 1
              ? (trips[0].price! + trips[1].price!).toStringAsFixed(2)
              : trips[0].price!.toStringAsFixed(2),
        }
      }),
    );
    log('body ' + response.request.body);

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseElectronicModel reservationResponseElectronicModel =
        ReservationResponseElectronicModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseElectronicModel;
  }

  Future<ReservationResponseCreditCard?> chargeusingcard({
    required int custId,
    required String amount,
    required String cardNumber,
    required String cardExpiryYear,
    required String cvv,
    required String cardExpiryMonth,
  }) async {
    print('helloooooo');
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final msg = jsonEncode({
      "CustomerId": custId,
      "amount": amount,
      "cardNumber": cardNumber,
      "cardExpiryYear": cardExpiryYear,
      "cardExpiryMonth": cardExpiryMonth,
      "cvv": cvv,
      "countryID": countryid
    });

    print(msg);
    var response = await apiConsumer.post(EndPoints.chargecard, body: msg);
    print(" Body " + response.request.toString());

    log('charge Response ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseCreditCard reservationResponseCreditCard =
        ReservationResponseCreditCard.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseCreditCard;
  }

  Future<ReservationResponseCreditCard?> addReservationCreditCard({
    required int custId,
    int? paymentMethodID,
    required int paymentTypeID,
    required String promoid,
    required List<TripReservationList> trips,
    required String cardNumber,
    required String cardExpiryYear,
    required String cvv,
    required String cardExpiryMonth,
  }) async {
    print('helloooooo');
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final msg = jsonEncode({
      "TripReservationList": [
        {
          "SeatIds": trips[0].seatIds,
          "TripID": trips[0].tripId,
          "FromStationID": trips[0].fromStationId,
          "ToStationID": trips[0].toStationId,
          "TripDate": trips[0].tripDate.toString(),
          "Price": trips[0].price!.toStringAsFixed(2).toString(),
          "Discount": trips[0].discount,
          "LineID": trips[0].lineId,
          "ServiceTypeID": trips[0].serviceTypeId,
          "BusID": trips[0].busId
        },
        trips.length > 1
            ? {
                "SeatIds": trips[1].seatIds,
                "TripID": trips[1].tripId,
                "FromStationID": trips[1].fromStationId,
                "ToStationID": trips[1].toStationId,
                "TripDate": trips[1].tripDate.toString(),
                "Price": trips[1].price!.toStringAsFixed(2).toString(),
                "Discount": trips[1].discount,
                "LineID": trips[1].lineId,
                "ServiceTypeID": trips[1].serviceTypeId,
                "BusID": trips[1].busId
              }
            : []
      ],
      "CustomerID": custId,
      "CountryID": countryid,
      "PromoCodeID": promoid,
      "PaymentTypeID": paymentTypeID,
      "PaymentMethodID": paymentMethodID,
      "cardPaymentModel": {
        "CustomerId": custId,
        "amount": trips.length > 1
            ? (trips[0].price! + trips[1].price!).toStringAsFixed(2)
            : trips[0].price!.toStringAsFixed(2).toString(),
        "cardNumber": cardNumber,
        "cardExpiryYear": cardExpiryYear,
        "cardExpiryMonth": cardExpiryMonth,
        "cvv": cvv,
      },
    });

    print(msg);
    var response = await apiConsumer.post(EndPoints.reservation, body: msg);
    log('body ' + response.request.body);

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseCreditCard reservationResponseCreditCard =
        ReservationResponseCreditCard.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseCreditCard;
  }
}
