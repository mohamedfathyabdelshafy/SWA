import 'dart:convert';
import 'dart:developer';

import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/Swa_umra/models/City_umra_model.dart';
import 'package:swa/features/Swa_umra/models/Transportaion_list_model.dart';
import 'package:swa/features/Swa_umra/models/Trip_umra_model.dart';
import 'package:swa/features/Swa_umra/models/Umra_tickets_model.dart';
import 'package:swa/features/Swa_umra/models/accomidation_model.dart';
import 'package:swa/features/Swa_umra/models/campainlistmodel.dart';
import 'package:swa/features/Swa_umra/models/packages_list_model.dart';
import 'package:swa/features/Swa_umra/models/campain_model.dart';
import 'package:swa/features/Swa_umra/models/page_model.dart';
import 'package:swa/features/Swa_umra/models/payment_type_model.dart';
import 'package:swa/features/Swa_umra/models/programs_model.dart';
import 'package:swa/features/Swa_umra/models/seats_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/app_info/data/models/city_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/promocode_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/send_message_model.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Electronic_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_response_MyWallet_model.dart';
import 'package:swa/select_payment2/data/models/policyTicket_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UmraRepos {
  final ApiConsumer apiConsumer = sl();

  Future getTripUmraType() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer
        .get("${EndPoints.baseUrl}TripUmraType/GetList?countryID=$countryid");

    log(" station from" + response.body);
    var decode = json.decode(response.body);
    TripUmramodel linesModel = TripUmramodel.fromJson(decode);
    return linesModel;
  }

  Future getcity() async {
    var response = await apiConsumer
        .get("${EndPoints.baseUrl}TripUmra/GetCityList?countryID=3");

    log(" station from" + response.body);
    var decode = json.decode(response.body);
    CityUmramodel linesModel = CityUmramodel.fromJson(decode);
    return linesModel;
  }

  Future getcampaint() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}TripUmra/GetCompainList?countryID=$countryid");

    log(" campain " + response.body);
    var decode = json.decode(response.body);
    CampainModel linesModel = CampainModel.fromJson(decode);
    return linesModel;
  }

  Future getseats({int? tripid}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}Trip/GetSingleTripDetails?tripId=$tripid&countryID=$countryid");

    log(" bus eats " + response.body);
    var decode = json.decode(response.body);
    Seatsmodel seatsmodel = Seatsmodel.fromJson(decode);
    return seatsmodel;
  }

  Future holdseat({int? tripid, int? seatId}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer.post(
        "${EndPoints.baseUrl}TripUmra/HoldSeat?seatId=$seatId&tripId=$tripid");

    log(" hold seat " + response.body);
    var decode = json.decode(response.body);
    SendMessageModel seatsmodel = SendMessageModel.fromJson(decode);
    return seatsmodel;
  }

  Future removeholdseats({int? tripid, List? seatId}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var data = json.encode({"seatListID": seatId, "tripId": tripid});
    var response = await apiConsumer.post(
      "${EndPoints.baseUrl}TripUmra/RemoveHoldSeat",
      body: data,
    );

    log(" remove hold seat " + response.body);
    var decode = json.decode(response.body);
    SendMessageModel seatsmodel = SendMessageModel.fromJson(decode);
    return seatsmodel;
  }

  Future checkpromocode({required String code}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var data = json.encode({
      "TripReservationList": [
        for (int i = 0; i < UmraDetails.finaltransportation!.length; i++)
          {
            "SeatIds": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber,
            "TripID": UmraDetails.finaltransportation![i].tripId,
            "FromStationID": UmraDetails.finaltransportation![i].fromStationId,
            "ToStationID": UmraDetails.finaltransportation![i].toStationId,
            "TripDate": UmraDetails.finaltransportation![i].tripDate.toString(),
            "Price": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .totalprice,
            "LineID": UmraDetails.finaltransportation![i].lineId,
            "ServiceTypeID": UmraDetails.finaltransportation![i].serviceTypeId,
            "BusID": UmraDetails.finaltransportation![i].busId,
            "TripUmrahTransportationID":
                UmraDetails.finaltransportation![i].tripUmrahTransportationId
          },
      ],
      "TripUmrahID": UmraDetails.tripUmrahID,
      "CustomerID": Routes.user!.customerId,
      "CountryID": countryid,
      "PromoCode": code,
      "dateTypeID": UmraDetails.dateTypeID,
      "toCurrency": Routes.curruncy,
      "WithTransportaion": UmraDetails.finaltransportation?.isNotEmpty ?? false,
      "WithResidence": UmraDetails.finalaccomidationRoom.isNotEmpty,
      "WithProgram": UmraDetails.finalprogramslist.isNotEmpty,
      "TotalPriceUmrah": UmraDetails.totalPriceUmrah,
      "PriceTransport": UmraDetails.totlaPriceTransport,
      "PriceResidence": UmraDetails.totlaPriceResidence,
      "PriceProgram": UmraDetails.totlaPriceProgram,
    });

    log(data.toString());
    var response = await apiConsumer.post(
      "${EndPoints.baseUrl}TripUmra/CheckPromoCode",
      body: data,
    );

    log(" promocode " + response.body);
    var decode = json.decode(response.body);
    Promocodemodel seatsmodel = Promocodemodel.fromJson(decode);
    return seatsmodel;
  }

  Future getpackageslist(
      {required String city,
      required String date,
      required int typeid,
      int? umrahReservationID,
      required int campainid}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    print(
        "${EndPoints.baseUrl}TripUmra/GetPackageList?cityID=$city&tripDate=$date&campianID=$campainid&tripTypeUmrahID=$typeid&dateTypeID=${UmraDetails.dateTypeID}${umrahReservationID != null ? '&umrahReservationID=$umrahReservationID' : ''}");
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}TripUmra/GetPackageList?cityID=$city&tripDate=$date&campianID=$campainid&tripTypeUmrahID=$typeid&dateTypeID=${UmraDetails.dateTypeID}&countryID=$countryid${umrahReservationID != null ? '&umrahReservationID=$umrahReservationID' : ''}");

    log(" campain " + response.body);
    var decode = json.decode(response.body);
    if (decode['status'] == 'success') {
      PackagesModel linesModel = PackagesModel.fromJson(decode);
      return linesModel;
    }
  }

  Future Getcampainlist() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}TripUmra/GetCompainList?countryID=$countryid");

    log(" campains " + response.body);
    var decode = json.decode(response.body);
    if (decode['status'] == 'success') {
      Campainlistmodel linesModel = Campainlistmodel.fromJson(decode);
      return linesModel;
    }
  }

  Future addReservationMyWallet({
    required int paymentTypeID,
    required int PaymentMethodID,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var data = json.encode({
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "Date": UmraDetails.tripdate,
      "dateTypeID": UmraDetails.dateTypeID,
      "CampainID": UmraDetails.campainid,
      "CityID": UmraDetails.cityid,
      "PromoCodeID": UmraDetails.promocodid,
      "PaymentMethodID": PaymentMethodID,
      "toCurrency": Routes.curruncy,
      "TripTypeUmrahID": UmraDetails.tripTypeUmrahID,
      "PaymentTypeID": paymentTypeID,
      "IsPaid": true,
      "PromoCode": UmraDetails.promocode,
      "TripUmrahID": UmraDetails.tripUmrahID,
      "WithTransportaion": UmraDetails.finaltransportation?.isNotEmpty ?? false,
      "WithResidence": UmraDetails.finalaccomidationRoom.isNotEmpty ?? false,
      "WithProgram": UmraDetails.finalprogramslist.isNotEmpty,
      "TotalPriceUmrah": UmraDetails.totalPriceUmrah,
      "PriceTransport": UmraDetails.totlaPriceTransport,
      "PriceAccommodation": UmraDetails.totlaPriceResidence,
      "PriceProgram": UmraDetails.totlaPriceProgram,
      "Discount": UmraDetails.dicount,
      "TotalPriceAfterDiscount": UmraDetails.afterdiscount,
      "TransportationList": [
        for (int i = 0; i < UmraDetails.finaltransportation!.length; i++)
          {
            "SeatIds": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber,
            "Price": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .totalprice,
            "PersonCount": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber
                .length,
            "TripID": UmraDetails.finaltransportation![i].tripId,
            "FromStationID": UmraDetails.finaltransportation![i].fromStationId,
            "ToStationID": UmraDetails.finaltransportation![i].toStationId,
            "TripDate": UmraDetails.finaltransportation![i].tripDate.toString(),
            "LineID": UmraDetails.finaltransportation![i].lineId,
            "ServiceTypeID": UmraDetails.finaltransportation![i].serviceTypeId,
            "BusID": UmraDetails.finaltransportation![i].busId,
            "TripUmrahTransportationID":
                UmraDetails.finaltransportation![i].tripUmrahTransportationId,
          }
      ],
      "AccommodationList": [
        for (int i = 0; i < UmraDetails.finalaccomidationRoom.length; i++)
          for (int j = 0;
              j < UmraDetails.finalaccomidationRoom[i].customernumbers.length;
              j++)
            if (UmraDetails.finalaccomidationRoom[i].customernumbers[j] > 0)
              {
                "Price": UmraDetails.finalaccomidationRoom[i].room[j].price *
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "PersonCount":
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "TripUmrahAccommodationID":
                    UmraDetails.finalaccomidationRoom[i].room[j].accomdationId,
                "AccommodationRoomID": UmraDetails
                    .finalaccomidationRoom[i].room[j].accomodationRoomTypeId
              }
      ],
      "ProgramList": [
        for (int i = 0; i < UmraDetails.finalprogramslist.length; i++)
          {
            "Price": UmraDetails.finalprogramslist[i].price *
                UmraDetails.finalcustomersprograms[i],
            "PersonCount": UmraDetails.finalcustomersprograms[i],
            "TripUmrahProgramID":
                UmraDetails.finalprogramslist[i].tripUnrahProgramId
          }
      ]
    });
    var response = await apiConsumer.post(
      EndPoints.reservationUmra,
      body: data,
    );
    log('body ' + data.toString());

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseMyWalletModel reservationResponseMyWalletModel =
        ReservationResponseMyWalletModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future Edditreservation({
    required int resrvationid,
    int? paymentid,
    int? paymentTypeID,
    int? paymentMethodID,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var datapayment = json.encode({
      "PaymentMethodID": paymentMethodID,
      "PaymentTypeID": paymentTypeID,
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "Date": UmraDetails.tripdate,
      "dateTypeID": UmraDetails.dateTypeID,
      "CampainID": UmraDetails.campainid,
      "CityID": UmraDetails.cityid,
      "toCurrency": Routes.curruncy,
      "PromoCodeID": UmraDetails.promocodid,
      "TripTypeUmrahID": UmraDetails.tripTypeUmrahID,
      "IsPaid": true,
      "PromoCode": UmraDetails.promocode,
      "TripUmrahID": UmraDetails.tripUmrahID,
      "WithTransportaion": UmraDetails.finaltransportation?.isNotEmpty ?? false,
      "WithResidence": UmraDetails.finalaccomidationRoom.isNotEmpty ?? false,
      "WithProgram": UmraDetails.finalprogramslist.isNotEmpty,
      "TotalPriceUmrah": UmraDetails.totalPriceUmrah,
      "PriceTransport": UmraDetails.totlaPriceTransport,
      "PriceAccommodation": UmraDetails.totlaPriceResidence,
      "PriceProgram": UmraDetails.totlaPriceProgram,
      "Discount": UmraDetails.dicount,
      "TotalPriceAfterDiscount": UmraDetails.afterdiscount,
      "TransportationList": [
        for (int i = 0; i < UmraDetails.finaltransportation!.length; i++)
          {
            "SeatIds": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber,
            "Price": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .totalprice,
            "PersonCount": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber
                .length,
            "TripID": UmraDetails.finaltransportation![i].tripId,
            "FromStationID": UmraDetails.finaltransportation![i].fromStationId,
            "ToStationID": UmraDetails.finaltransportation![i].toStationId,
            "TripDate": UmraDetails.finaltransportation![i].tripDate.toString(),
            "LineID": UmraDetails.finaltransportation![i].lineId,
            "ServiceTypeID": UmraDetails.finaltransportation![i].serviceTypeId,
            "BusID": UmraDetails.finaltransportation![i].busId,
            "TripUmrahTransportationID":
                UmraDetails.finaltransportation![i].tripUmrahTransportationId,
          }
      ],
      "AccommodationList": [
        for (int i = 0; i < UmraDetails.finalaccomidationRoom.length; i++)
          for (int j = 0;
              j < UmraDetails.finalaccomidationRoom[i].customernumbers.length;
              j++)
            if (UmraDetails.finalaccomidationRoom[i].customernumbers[j] > 0)
              {
                "Price": UmraDetails.finalaccomidationRoom[i].room[j].price *
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "PersonCount":
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "TripUmrahAccommodationID":
                    UmraDetails.finalaccomidationRoom[i].room[j].accomdationId,
                "AccommodationRoomID": UmraDetails
                    .finalaccomidationRoom[i].room[j].accomodationRoomTypeId
              }
      ],
      "ProgramList": [
        for (int i = 0; i < UmraDetails.finalprogramslist.length; i++)
          {
            "Price": UmraDetails.finalprogramslist[i].price *
                UmraDetails.finalcustomersprograms[i],
            "PersonCount": UmraDetails.finalcustomersprograms[i],
            "TripUmrahProgramID":
                UmraDetails.finalprogramslist[i].tripUnrahProgramId
          }
      ],
      "UmrahReservationID": resrvationid,
      "DifferentPrice": UmraDetails.differentPrice.toStringAsFixed(2),
    });
    var response = await apiConsumer.post(
      EndPoints.editreservation,
      body: datapayment,
    );
    log('body ' + datapayment.toString());

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseMyWalletModel reservationResponseMyWalletModel =
        ReservationResponseMyWalletModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future addReservationCardpay({
    required int paymentTypeID,
    required int PaymentMethodID,
    required String cardNumber,
    required String cardExpiryYear,
    required String cvv,
    required String cardExpiryMonth,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var data = json.encode({
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "Date": UmraDetails.tripdate,
      "dateTypeID": UmraDetails.dateTypeID,
      "toCurrency": Routes.curruncy,
      "CampainID": UmraDetails.campainid,
      "CityID": UmraDetails.cityid,
      "PromoCodeID": UmraDetails.promocodid,
      "PaymentMethodID": PaymentMethodID,
      "PaymentTypeID": paymentTypeID,
      "IsPaid": false,
      "TripTypeUmrahID": UmraDetails.tripTypeUmrahID,
      "PromoCode": UmraDetails.promocode,
      "TripUmrahID": UmraDetails.tripUmrahID,
      "WithTransportaion": UmraDetails.finaltransportation?.isNotEmpty ?? false,
      "WithResidence": UmraDetails.finalaccomidationRoom.isNotEmpty ?? false,
      "WithProgram": UmraDetails.finalprogramslist.isNotEmpty,
      "TotalPriceUmrah": UmraDetails.totalPriceUmrah,
      "PriceTransport": UmraDetails.totlaPriceTransport,
      "PriceAccommodation": UmraDetails.totlaPriceResidence,
      "PriceProgram": UmraDetails.totlaPriceProgram,
      "Discount": UmraDetails.dicount,
      "TotalPriceAfterDiscount": UmraDetails.afterdiscount,
      "TransportationList": [
        for (int i = 0; i < UmraDetails.finaltransportation!.length; i++)
          {
            "SeatIds": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber,
            "Price": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .totalprice,
            "PersonCount": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber
                .length,
            "TripID": UmraDetails.finaltransportation![i].tripId,
            "FromStationID": UmraDetails.finaltransportation![i].fromStationId,
            "ToStationID": UmraDetails.finaltransportation![i].toStationId,
            "TripDate": UmraDetails.finaltransportation![i].tripDate.toString(),
            "LineID": UmraDetails.finaltransportation![i].lineId,
            "ServiceTypeID": UmraDetails.finaltransportation![i].serviceTypeId,
            "BusID": UmraDetails.finaltransportation![i].busId,
            "TripUmrahTransportationID":
                UmraDetails.finaltransportation![i].tripUmrahTransportationId,
          }
      ],
      "AccommodationList": [
        for (int i = 0; i < UmraDetails.finalaccomidationRoom.length; i++)
          for (int j = 0;
              j < UmraDetails.finalaccomidationRoom[i].customernumbers.length;
              j++)
            if (UmraDetails.finalaccomidationRoom[i].customernumbers[j] > 0)
              {
                "Price": UmraDetails.finalaccomidationRoom[i].room[j].price *
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "PersonCount":
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "TripUmrahAccommodationID":
                    UmraDetails.finalaccomidationRoom[i].room[j].accomdationId,
                "AccommodationRoomID": UmraDetails
                    .finalaccomidationRoom[i].room[j].accomodationRoomTypeId
              }
      ],
      "ProgramList": [
        for (int i = 0; i < UmraDetails.finalprogramslist.length; i++)
          {
            "Price": UmraDetails.finalprogramslist[i].price *
                UmraDetails.finalcustomersprograms[i],
            "PersonCount": UmraDetails.finalcustomersprograms[i],
            "TripUmrahProgramID":
                UmraDetails.finalprogramslist[i].tripUnrahProgramId
          }
      ],
      "cardPaymentModel": {
        "CustomerId": Routes.customerid,
        "amount": UmraDetails.afterdiscount.toStringAsFixed(2),
        "cardNumber": cardNumber,
        "cardExpiryYear": cardExpiryYear,
        "cardExpiryMonth": cardExpiryMonth,
        "cvv": cvv,
      },
    });
    var response = await apiConsumer.post(
      EndPoints.reservationUmra,
      body: data,
    );
    log('body ' + data.toString());

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseCreditCard reservationResponseMyWalletModel =
        ReservationResponseCreditCard.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future editreservationcard({
    required int paymentTypeID,
    required int PaymentMethodID,
    required int umrareservationid,
    required String cardNumber,
    required String cardExpiryYear,
    required String cvv,
    required String cardExpiryMonth,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var data = json.encode({
      "PaymentMethodID": PaymentMethodID,
      "PaymentTypeID": paymentTypeID,
      "CustomerID": Routes.customerid,
      "dateTypeID": UmraDetails.dateTypeID,
      "CountryID": countryid,
      "toCurrency": Routes.curruncy,
      "Date": UmraDetails.tripdate,
      "CampainID": UmraDetails.campainid,
      "CityID": UmraDetails.cityid,
      "PromoCodeID": UmraDetails.promocodid,
      "TripTypeUmrahID": UmraDetails.tripTypeUmrahID,
      "IsPaid": false,
      "PromoCode": UmraDetails.promocode,
      "TripUmrahID": UmraDetails.tripUmrahID,
      "WithTransportaion": UmraDetails.finaltransportation?.isNotEmpty ?? false,
      "WithResidence": UmraDetails.finalaccomidationRoom.isNotEmpty ?? false,
      "WithProgram": UmraDetails.finalprogramslist.isNotEmpty,
      "TotalPriceUmrah": UmraDetails.totalPriceUmrah,
      "PriceTransport": UmraDetails.totlaPriceTransport,
      "PriceAccommodation": UmraDetails.totlaPriceResidence,
      "PriceProgram": UmraDetails.totlaPriceProgram,
      "Discount": UmraDetails.dicount,
      "TotalPriceAfterDiscount": UmraDetails.afterdiscount,
      "TransportationList": [
        for (int i = 0; i < UmraDetails.finaltransportation!.length; i++)
          {
            "SeatIds": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber,
            "Price": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .totalprice,
            "PersonCount": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber
                .length,
            "TripID": UmraDetails.finaltransportation![i].tripId,
            "FromStationID": UmraDetails.finaltransportation![i].fromStationId,
            "ToStationID": UmraDetails.finaltransportation![i].toStationId,
            "TripDate": UmraDetails.finaltransportation![i].tripDate.toString(),
            "LineID": UmraDetails.finaltransportation![i].lineId,
            "ServiceTypeID": UmraDetails.finaltransportation![i].serviceTypeId,
            "BusID": UmraDetails.finaltransportation![i].busId,
            "TripUmrahTransportationID":
                UmraDetails.finaltransportation![i].tripUmrahTransportationId,
          }
      ],
      "AccommodationList": [
        for (int i = 0; i < UmraDetails.finalaccomidationRoom.length; i++)
          for (int j = 0;
              j < UmraDetails.finalaccomidationRoom[i].customernumbers.length;
              j++)
            if (UmraDetails.finalaccomidationRoom[i].customernumbers[j] > 0)
              {
                "Price": UmraDetails.finalaccomidationRoom[i].room[j].price *
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "PersonCount":
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "TripUmrahAccommodationID":
                    UmraDetails.finalaccomidationRoom[i].room[j].accomdationId,
                "AccommodationRoomID": UmraDetails
                    .finalaccomidationRoom[i].room[j].accomodationRoomTypeId
              }
      ],
      "ProgramList": [
        for (int i = 0; i < UmraDetails.finalprogramslist.length; i++)
          {
            "Price": UmraDetails.finalprogramslist[i].price *
                UmraDetails.finalcustomersprograms[i],
            "PersonCount": UmraDetails.finalcustomersprograms[i],
            "TripUmrahProgramID":
                UmraDetails.finalprogramslist[i].tripUnrahProgramId
          }
      ],
      "UmrahReservationID": umrareservationid,
      "DifferentPrice": UmraDetails.differentPrice.toStringAsFixed(2),
      "cardPaymentModel": {
        "CustomerId": Routes.customerid,
        "amount": UmraDetails.differentPrice.toStringAsFixed(2),
        "cardNumber": cardNumber,
        "cardExpiryYear": cardExpiryYear,
        "cardExpiryMonth": cardExpiryMonth,
        "cvv": cvv,
      },
    });
    var response = await apiConsumer.post(
      EndPoints.editreservation,
      body: data,
    );
    log('body ' + data.toString());

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseCreditCard reservationResponseMyWalletModel =
        ReservationResponseCreditCard.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future fawrypayment({
    required int paymentTypeID,
    required int PaymentMethodID,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var data = json.encode({
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "Date": UmraDetails.tripdate,
      "dateTypeID": UmraDetails.dateTypeID,
      "CampainID": UmraDetails.campainid,
      "CityID": UmraDetails.cityid,
      "PromoCodeID": UmraDetails.promocodid,
      "toCurrency": Routes.curruncy,
      "PaymentMethodID": PaymentMethodID,
      "PaymentTypeID": paymentTypeID,
      "IsPaid": false,
      "TripTypeUmrahID": UmraDetails.tripTypeUmrahID,
      "PromoCode": UmraDetails.promocode,
      "TripUmrahID": UmraDetails.tripUmrahID,
      "WithTransportaion": UmraDetails.finaltransportation?.isNotEmpty ?? false,
      "WithResidence": UmraDetails.finalaccomidationRoom.isNotEmpty ?? false,
      "WithProgram": UmraDetails.finalprogramslist.isNotEmpty,
      "TotalPriceUmrah": UmraDetails.totalPriceUmrah,
      "PriceTransport": UmraDetails.totlaPriceTransport,
      "PriceAccommodation": UmraDetails.totlaPriceResidence,
      "PriceProgram": UmraDetails.totlaPriceProgram,
      "Discount": UmraDetails.dicount,
      "TotalPriceAfterDiscount": UmraDetails.afterdiscount,
      "TransportationList": [
        for (int i = 0; i < UmraDetails.finaltransportation!.length; i++)
          {
            "SeatIds": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber,
            "Price": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .totalprice,
            "PersonCount": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber
                .length,
            "TripID": UmraDetails.finaltransportation![i].tripId,
            "FromStationID": UmraDetails.finaltransportation![i].fromStationId,
            "ToStationID": UmraDetails.finaltransportation![i].toStationId,
            "TripDate": UmraDetails.finaltransportation![i].tripDate.toString(),
            "LineID": UmraDetails.finaltransportation![i].lineId,
            "ServiceTypeID": UmraDetails.finaltransportation![i].serviceTypeId,
            "BusID": UmraDetails.finaltransportation![i].busId,
            "TripUmrahTransportationID":
                UmraDetails.finaltransportation![i].tripUmrahTransportationId,
          }
      ],
      "AccommodationList": [
        for (int i = 0; i < UmraDetails.finalaccomidationRoom.length; i++)
          for (int j = 0;
              j < UmraDetails.finalaccomidationRoom[i].customernumbers.length;
              j++)
            if (UmraDetails.finalaccomidationRoom[i].customernumbers[j] > 0)
              {
                "Price": UmraDetails.finalaccomidationRoom[i].room[j].price *
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "PersonCount":
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "TripUmrahAccommodationID":
                    UmraDetails.finalaccomidationRoom[i].room[j].accomdationId,
                "AccommodationRoomID": UmraDetails
                    .finalaccomidationRoom[i].room[j].accomodationRoomTypeId
              }
      ],
      "ProgramList": [
        for (int i = 0; i < UmraDetails.finalprogramslist.length; i++)
          {
            "Price": UmraDetails.finalprogramslist[i].price *
                UmraDetails.finalcustomersprograms[i],
            "PersonCount": UmraDetails.finalcustomersprograms[i],
            "TripUmrahProgramID":
                UmraDetails.finalprogramslist[i].tripUnrahProgramId
          }
      ],
      "RefNoModel": {
        "CustomerId": Routes.customerid,
        "Amount": UmraDetails.afterdiscount.toStringAsFixed(2),
      }
    });
    var response = await apiConsumer.post(
      EndPoints.reservationUmra,
      body: data,
    );
    log('body ' + data.toString());

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseElectronicModel reservationResponseMyWalletModel =
        ReservationResponseElectronicModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future fawryEdit({
    required int paymentTypeID,
    required int PaymentMethodID,
    required int umrahReservationID,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var data = json.encode({
      "PaymentMethodID": PaymentMethodID,
      "PaymentTypeID": paymentTypeID,
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "Date": UmraDetails.tripdate,
      "dateTypeID": UmraDetails.dateTypeID,
      "CampainID": UmraDetails.campainid,
      "CityID": UmraDetails.cityid,
      "toCurrency": Routes.curruncy,
      "PromoCodeID": UmraDetails.promocodid,
      "TripTypeUmrahID": UmraDetails.tripTypeUmrahID,
      "IsPaid": false,
      "PromoCode": UmraDetails.promocode,
      "TripUmrahID": UmraDetails.tripUmrahID,
      "WithTransportaion": UmraDetails.finaltransportation?.isNotEmpty ?? false,
      "WithResidence": UmraDetails.finalaccomidationRoom.isNotEmpty ?? false,
      "WithProgram": UmraDetails.finalprogramslist.isNotEmpty,
      "TotalPriceUmrah": UmraDetails.totalPriceUmrah,
      "PriceTransport": UmraDetails.totlaPriceTransport,
      "PriceAccommodation": UmraDetails.totlaPriceResidence,
      "PriceProgram": UmraDetails.totlaPriceProgram,
      "Discount": UmraDetails.dicount,
      "TotalPriceAfterDiscount": UmraDetails.afterdiscount,
      "TransportationList": [
        for (int i = 0; i < UmraDetails.finaltransportation!.length; i++)
          {
            "SeatIds": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber,
            "Price": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .totalprice,
            "PersonCount": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber
                .length,
            "TripID": UmraDetails.finaltransportation![i].tripId,
            "FromStationID": UmraDetails.finaltransportation![i].fromStationId,
            "ToStationID": UmraDetails.finaltransportation![i].toStationId,
            "TripDate": UmraDetails.finaltransportation![i].tripDate.toString(),
            "LineID": UmraDetails.finaltransportation![i].lineId,
            "ServiceTypeID": UmraDetails.finaltransportation![i].serviceTypeId,
            "BusID": UmraDetails.finaltransportation![i].busId,
            "TripUmrahTransportationID":
                UmraDetails.finaltransportation![i].tripUmrahTransportationId,
          }
      ],
      "AccommodationList": [
        for (int i = 0; i < UmraDetails.finalaccomidationRoom.length; i++)
          for (int j = 0;
              j < UmraDetails.finalaccomidationRoom[i].customernumbers.length;
              j++)
            if (UmraDetails.finalaccomidationRoom[i].customernumbers[j] > 0)
              {
                "Price": UmraDetails.finalaccomidationRoom[i].room[j].price *
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "PersonCount":
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "TripUmrahAccommodationID":
                    UmraDetails.finalaccomidationRoom[i].room[j].accomdationId,
                "AccommodationRoomID": UmraDetails
                    .finalaccomidationRoom[i].room[j].accomodationRoomTypeId
              }
      ],
      "ProgramList": [
        for (int i = 0; i < UmraDetails.finalprogramslist.length; i++)
          {
            "Price": UmraDetails.finalprogramslist[i].price *
                UmraDetails.finalcustomersprograms[i],
            "PersonCount": UmraDetails.finalcustomersprograms[i],
            "TripUmrahProgramID":
                UmraDetails.finalprogramslist[i].tripUnrahProgramId
          }
      ],
      "UmrahReservationID": umrahReservationID,
      "DifferentPrice": UmraDetails.differentPrice.toStringAsFixed(2),
      "RefNoModel": {
        "CustomerId": Routes.customerid,
        "Amount": UmraDetails.differentPrice.toStringAsFixed(2),
      }
    });
    var response = await apiConsumer.post(
      EndPoints.editreservation,
      body: data,
    );
    log('body ' + data.toString());

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseElectronicModel reservationResponseMyWalletModel =
        ReservationResponseElectronicModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future getpolicy({required String type}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer
        .get("${EndPoints.baseUrl}TripUmra/$type?countryID=$countryid");

    log("policy" + res.body);
    var decode = json.decode(res.body);
    Policyticketmodel linesModel = Policyticketmodel.fromJson(decode);
    return linesModel;
  }

  Future cancelumraTicket({required int reservationID}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.post(
        "${EndPoints.baseUrl}TripUmra/CancelReservation?umrahReservation=$reservationID&countryID=$countryid");

    log("policy" + res.body);
    var decode = json.decode(res.body);
    SendMessageModel linesModel = SendMessageModel.fromJson(decode);
    return linesModel;
  }

  Future GetPageList() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer
        .get("${EndPoints.baseUrl}TripUmra/GetPageList?countryID=$countryid");

    log("Pagelistmodel " + res.body);
    var decode = json.decode(res.body);
    Pagelistmodel linesModel = Pagelistmodel.fromJson(decode);
    return linesModel;
  }

  Future getTransportation(
      {required int tripUmrahID, int? reservationID}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}TripUmra/GetTransportationList?tripUmrahID=$tripUmrahID&dateTypeID=${UmraDetails.dateTypeID}&toCurrency=${Routes.curruncy}&countryID=$countryid${reservationID != null ? '&umrahReservationID=$reservationID' : ''}");

    log("Transportation  " + res.body);
    var decode = json.decode(res.body);
    TransportationListModel linesModel =
        TransportationListModel.fromJson(decode);
    return linesModel;
  }

  Future getAccomidation(
      {required int tripUmrahID, int? umrahReservationID}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    print(
        "${EndPoints.baseUrl}TripUmra/GetAccommodationList?tripUmrahID=$tripUmrahID&dateTypeID=${UmraDetails.dateTypeID}&toCurrency=${Routes.curruncy}&countryID=$countryid${umrahReservationID != null ? '&umrahReservationID=$umrahReservationID' : ''}");

    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}TripUmra/GetAccommodationList?tripUmrahID=$tripUmrahID&dateTypeID=${UmraDetails.dateTypeID}&toCurrency=${Routes.curruncy}&countryID=$countryid${umrahReservationID != null ? '&umrahReservationID=$umrahReservationID' : ''}");

    log("AccomidationModel  " + res.body);
    var decode = json.decode(res.body);
    AccomidationModel linesModel = AccomidationModel.fromJson(decode);
    return linesModel;
  }

  Future getPrograms(
      {required int tripUmrahID, int? umrahReservationID}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    print(
        "${EndPoints.baseUrl}TripUmra/GetProgramList?tripUmrahID=$tripUmrahID${umrahReservationID != null ? '&umrahReservationID=$umrahReservationID' : ''}");
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}TripUmra/GetProgramList?tripUmrahID=$tripUmrahID&dateTypeID=${UmraDetails.dateTypeID}&toCurrency=${Routes.curruncy}&countryID=$countryid${umrahReservationID != null ? '&umrahReservationID=$umrahReservationID' : ''}");

    log("programs  " + res.body);
    var decode = json.decode(res.body);
    ProgramsModel linesModel = ProgramsModel.fromJson(decode);
    return linesModel;
  }

  Future getpayments() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}Payment/GetPageList?countryID=$countryid&includWallet=false");

    log("payment type  " + res.body);
    var decode = json.decode(res.body);
    Paymenttypemodel linesModel = Paymenttypemodel.fromJson(decode);
    return linesModel;
  }

  Future ellectronicwallet({
    required int paymentTypeID,
    required int PaymentMethodID,
    required String phone,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var data = json.encode({
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "PromoCodeID": UmraDetails.promocodid,
      "PaymentMethodID": PaymentMethodID,
      "PaymentTypeID": paymentTypeID,
      "IsPaid": false,
      "TripTypeUmrahID": UmraDetails.tripTypeUmrahID,
      "Date": UmraDetails.tripdate,
      "dateTypeID": UmraDetails.dateTypeID,
      "CampainID": UmraDetails.campainid,
      "toCurrency": Routes.curruncy,
      "CityID": UmraDetails.cityid,
      "PromoCode": UmraDetails.promocode,
      "TripUmrahID": UmraDetails.tripUmrahID,
      "WithTransportaion": UmraDetails.finaltransportation?.isNotEmpty ?? false,
      "WithResidence": UmraDetails.finalaccomidationRoom.isNotEmpty ?? false,
      "WithProgram": UmraDetails.finalprogramslist.isNotEmpty,
      "TotalPriceUmrah": UmraDetails.totalPriceUmrah,
      "PriceTransport": UmraDetails.totlaPriceTransport,
      "PriceAccommodation": UmraDetails.totlaPriceResidence,
      "PriceProgram": UmraDetails.totlaPriceProgram,
      "Discount": UmraDetails.dicount,
      "TotalPriceAfterDiscount": UmraDetails.afterdiscount,
      "TransportationList": [
        for (int i = 0; i < UmraDetails.finaltransportation!.length; i++)
          {
            "SeatIds": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber,
            "Price": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .totalprice,
            "PersonCount": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber
                .length,
            "TripID": UmraDetails.finaltransportation![i].tripId,
            "FromStationID": UmraDetails.finaltransportation![i].fromStationId,
            "ToStationID": UmraDetails.finaltransportation![i].toStationId,
            "TripDate": UmraDetails.finaltransportation![i].tripDate.toString(),
            "LineID": UmraDetails.finaltransportation![i].lineId,
            "ServiceTypeID": UmraDetails.finaltransportation![i].serviceTypeId,
            "BusID": UmraDetails.finaltransportation![i].busId,
            "TripUmrahTransportationID":
                UmraDetails.finaltransportation![i].tripUmrahTransportationId,
          }
      ],
      "AccommodationList": [
        for (int i = 0; i < UmraDetails.finalaccomidationRoom.length; i++)
          for (int j = 0;
              j < UmraDetails.finalaccomidationRoom[i].customernumbers.length;
              j++)
            if (UmraDetails.finalaccomidationRoom[i].customernumbers[j] > 0)
              {
                "Price": UmraDetails.finalaccomidationRoom[i].room[j].price *
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "PersonCount":
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "TripUmrahAccommodationID":
                    UmraDetails.finalaccomidationRoom[i].room[j].accomdationId,
                "AccommodationRoomID": UmraDetails
                    .finalaccomidationRoom[i].room[j].accomodationRoomTypeId
              }
      ],
      "ProgramList": [
        for (int i = 0; i < UmraDetails.finalprogramslist.length; i++)
          {
            "Price": UmraDetails.finalprogramslist[i].price *
                UmraDetails.finalcustomersprograms[i],
            "PersonCount": UmraDetails.finalcustomersprograms[i],
            "TripUmrahProgramID":
                UmraDetails.finalprogramslist[i].tripUnrahProgramId
          }
      ],
      "ewalletModel": {
        "customerId": Routes.customerid,
        "amount": UmraDetails.afterdiscount.toStringAsFixed(2),
        "mobile": phone,
      },
    });
    var response = await apiConsumer.post(
      EndPoints.reservationUmra,
      body: data,
    );
    log('body ' + data.toString());

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseElectronicModel reservationResponseMyWalletModel =
        ReservationResponseElectronicModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future Editellectronicwallet(
      {required int paymentTypeID,
      required int PaymentMethodID,
      required String phone,
      required int umrareservationid}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var data = json.encode({
      "PaymentMethodID": PaymentMethodID,
      "PaymentTypeID": paymentTypeID,
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "Date": UmraDetails.tripdate,
      "dateTypeID": UmraDetails.dateTypeID,
      "CampainID": UmraDetails.campainid,
      "CityID": UmraDetails.cityid,
      "PromoCodeID": UmraDetails.promocodid,
      "toCurrency": Routes.curruncy,
      "TripTypeUmrahID": UmraDetails.tripTypeUmrahID,
      "IsPaid": false,
      "PromoCode": UmraDetails.promocode,
      "TripUmrahID": UmraDetails.tripUmrahID,
      "WithTransportaion": UmraDetails.finaltransportation?.isNotEmpty ?? false,
      "WithResidence": UmraDetails.finalaccomidationRoom.isNotEmpty ?? false,
      "WithProgram": UmraDetails.finalprogramslist.isNotEmpty,
      "TotalPriceUmrah": UmraDetails.totalPriceUmrah,
      "PriceTransport": UmraDetails.totlaPriceTransport,
      "PriceAccommodation": UmraDetails.totlaPriceResidence,
      "PriceProgram": UmraDetails.totlaPriceProgram,
      "Discount": UmraDetails.dicount,
      "TotalPriceAfterDiscount": UmraDetails.afterdiscount,
      "TransportationList": [
        for (int i = 0; i < UmraDetails.finaltransportation!.length; i++)
          {
            "SeatIds": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber,
            "Price": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .totalprice,
            "PersonCount": UmraDetails.reservedseats
                .firstWhere((element) =>
                    element.tripid ==
                    UmraDetails.finaltransportation![i].tripId)
                .seatsnumber
                .length,
            "TripID": UmraDetails.finaltransportation![i].tripId,
            "FromStationID": UmraDetails.finaltransportation![i].fromStationId,
            "ToStationID": UmraDetails.finaltransportation![i].toStationId,
            "TripDate": UmraDetails.finaltransportation![i].tripDate.toString(),
            "LineID": UmraDetails.finaltransportation![i].lineId,
            "ServiceTypeID": UmraDetails.finaltransportation![i].serviceTypeId,
            "BusID": UmraDetails.finaltransportation![i].busId,
            "TripUmrahTransportationID":
                UmraDetails.finaltransportation![i].tripUmrahTransportationId,
          }
      ],
      "AccommodationList": [
        for (int i = 0; i < UmraDetails.finalaccomidationRoom.length; i++)
          for (int j = 0;
              j < UmraDetails.finalaccomidationRoom[i].customernumbers.length;
              j++)
            if (UmraDetails.finalaccomidationRoom[i].customernumbers[j] > 0)
              {
                "Price": UmraDetails.finalaccomidationRoom[i].room[j].price *
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "PersonCount":
                    UmraDetails.finalaccomidationRoom[i].customernumbers[j],
                "TripUmrahAccommodationID":
                    UmraDetails.finalaccomidationRoom[i].room[j].accomdationId,
                "AccommodationRoomID": UmraDetails
                    .finalaccomidationRoom[i].room[j].accomodationRoomTypeId
              }
      ],
      "ProgramList": [
        for (int i = 0; i < UmraDetails.finalprogramslist.length; i++)
          {
            "Price": UmraDetails.finalprogramslist[i].price *
                UmraDetails.finalcustomersprograms[i],
            "PersonCount": UmraDetails.finalcustomersprograms[i],
            "TripUmrahProgramID":
                UmraDetails.finalprogramslist[i].tripUnrahProgramId
          }
      ],
      "UmrahReservationID": umrareservationid,
      "DifferentPrice": UmraDetails.differentPrice.toStringAsFixed(2),
      "ewalletModel": {
        "customerId": Routes.customerid,
        "amount": UmraDetails.differentPrice.toStringAsFixed(2),
        "mobile": phone,
      },
    });
    var response = await apiConsumer.post(
      EndPoints.editreservation,
      body: data,
    );
    log('body ' + data.toString());

    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    ReservationResponseElectronicModel reservationResponseMyWalletModel =
        ReservationResponseElectronicModel.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return reservationResponseMyWalletModel;
  }

  Future<void> launchInWebView(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  Future getbookedumraticket() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    print(
        "${EndPoints.baseUrl}TripUmra/GetListUmrahBooking?customerID=${Routes.customerid}&countryID=$countryid&dateTypeID=${countryid == 1 ? 113 : 112}&toCurrency=${Routes.curruncy}");
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}TripUmra/GetListUmrahBooking?customerID=${Routes.customerid}&countryID=$countryid&dateTypeID=${countryid == 1 ? 113 : 112}&toCurrency=${Routes.curruncy}");

    log("umra Tickets  " + res.body);
    var decode = json.decode(res.body);
    UmraTicketsModel linesModel = UmraTicketsModel.fromJson(decode);
    return linesModel;
  }
}
