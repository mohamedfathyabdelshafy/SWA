import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsEditModel.dart';
import 'package:swa/features/forgot_password/data/models/message_response_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../models/BusSeatsModel.dart';

class BusLayoutRepo {
  final ApiConsumer apiConsumer;
  BusLayoutRepo({required this.apiConsumer});
  Future<BusSeatsModel> getBusSeatsData({required int tripId}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}Trip/GetSingleTripDetails?tripId=$tripId&countryID=$countryid");

    log('ReservationData response ' + response.body);

    var decodedResponse = json.decode(response.body);
    BusSeatsModel busSeatsModel = BusSeatsModel.fromJson(decodedResponse);
    return busSeatsModel;
  }

  Future<BusSeatsEditModel> getReservationSeatsData(
      {required int reservationID}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}Trip/GetCustomerTripDetails?customerID=${Routes.customerid}&reservationID=$reservationID&countryID=$countryid&dateTypeID=${UmraDetails.dateTypeID}&toCurrency=${Routes.curruncy}");

    log('ReservationData response ' + response.body);

    var decodedResponse = json.decode(response.body);
    BusSeatsEditModel busSeatsModel =
        BusSeatsEditModel.fromJson(decodedResponse);
    return busSeatsModel;
  }

  Future<MessageResponseModel> saveticketedit(
      {required int reservationID,
      required List<num> Seatsnumbers,
      required double price}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    log(Seatsnumbers.toString());
    double totalprice = price * Seatsnumbers.length;

    var response = await apiConsumer.post(
        body: jsonEncode({
          "SealListID": Seatsnumbers,
          "customerID": Routes.customerid,
          "reservationID": reservationID,
          "totalPrice": totalprice,
          "seatPrice": price,
          "countryID": countryid,
          "dateTypeID": countryid == 1 ? 113 : 112,
          "toCurrency": Routes.curruncy
        }),
        "${EndPoints.baseUrl}Reservation/EditReservation");
    log('ReservationData request ' + response.request.toString());

    log('ReservationData body ' + response.request.body.toString());

    log('ReservationData response ' + response.body);

    var decodedResponse = json.decode(response.body);
    MessageResponseModel busSeatsModel =
        MessageResponseModel.fromJson(decodedResponse);
    return busSeatsModel;
  }

  Future<MessageResponseModel> Seatholdfunction({
    required int setid,
    required int tripid,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var response = await apiConsumer.post(
        "${EndPoints.baseUrl}Reservation/HoldSeat?seatId=$setid&tripId=$tripid");

    log('sethold response ' + response.body);

    var decodedResponse = json.decode(response.body);
    MessageResponseModel busSeatsModel =
        MessageResponseModel.fromJson(decodedResponse);
    return busSeatsModel;
  }

  Future<MessageResponseModel> Removeholdfun({
    required int tripid,
    required List<num> Seatsnumbers,
  }) async {
    var response = await apiConsumer.post(
        body: jsonEncode({"seatListID": Seatsnumbers, "tripId": tripid}),
        "${EndPoints.baseUrl}/Reservation/RemoveHoldSeat");

    log('removehold response ' + response.body);

    var decodedResponse = json.decode(response.body);
    MessageResponseModel busSeatsModel =
        MessageResponseModel.fromJson(decodedResponse);
    return busSeatsModel;
  }
}
