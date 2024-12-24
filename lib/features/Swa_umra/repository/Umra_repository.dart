import 'dart:convert';
import 'dart:developer';

import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/Swa_umra/models/City_umra_model.dart';
import 'package:swa/features/Swa_umra/models/Trip_umra_model.dart';
import 'package:swa/features/Swa_umra/models/campain_list_model.dart';
import 'package:swa/features/Swa_umra/models/campain_model.dart';
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

class UmraRepos {
  final ApiConsumer apiConsumer = sl();

  Future getTripUmraType() async {
    var response =
        await apiConsumer.get("${EndPoints.baseUrl}TripUmraType/GetList");

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
    var response =
        await apiConsumer.get("${EndPoints.baseUrl}TripUmra/GetCompainList");

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
        "${EndPoints.baseUrl}Trip/GetSingleTripDetails?tripId=$tripid&countryID=3");

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
        {
          "SeatIds": UmraDetails.bookedseatsidgo,
          "TripID": UmraDetails.tripList.tripGoId,
          "FromStationID": UmraDetails.tripList.fromStationIdGo,
          "ToStationID": UmraDetails.tripList.toStationIdGo,
          "TripDate": UmraDetails.tripList.tripDateGo.toString(),
          "Price": (UmraDetails.tripList.price / 2) *
              UmraDetails.bookedseatsidgo.length,
          "LineID": UmraDetails.tripList.lineIdGo,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdGo,
          "BusID": UmraDetails.tripList.busIdGo
        },
        {
          "SeatIds": UmraDetails.bookedseatsback,
          "TripID": UmraDetails.tripList.tripIdBack,
          "FromStationID": UmraDetails.tripList.fromStationIdBack,
          "ToStationID": UmraDetails.tripList.toStationIdBack,
          "TripDate": UmraDetails.tripList.tripDateBack.toString(),
          "Price": (UmraDetails.tripList.price / 2) *
              UmraDetails.bookedseatsback.length,
          "LineID": UmraDetails.tripList.lineIdBack,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdBack,
          "BusID": UmraDetails.tripList.busIdBack
        }
      ],
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "PromoCode": code,
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

  Future getcampaginlist({required String city, required String date}) async {
    print(
        "${EndPoints.baseUrl}TripUmra/GetTripList?cityID=$city&tripDate=$date");
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}TripUmra/GetTripList?cityID=$city&tripDate=$date");

    log(" campain " + response.body);
    var decode = json.decode(response.body);
    Triplistmodel linesModel = Triplistmodel.fromJson(decode);
    return linesModel;
  }

  Future addReservationMyWallet({
    required int paymentTypeID,
    required int PaymentMethodID,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var data = json.encode({
      "TripReservationList": [
        {
          "SeatIds": UmraDetails.bookedseatsidgo,
          "TripID": UmraDetails.tripList.tripGoId,
          "FromStationID": UmraDetails.tripList.fromStationIdGo,
          "ToStationID": UmraDetails.tripList.toStationIdGo,
          "TripDate": UmraDetails.tripList.tripDateGo.toString(),
          "Price": UmraDetails.afterdiscount / 2,
          "Discount": (UmraDetails.dicount / 2).toString(),
          "LineID": UmraDetails.tripList.lineIdGo,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdGo,
          "BusID": UmraDetails.tripList.busIdGo
        },
        {
          "SeatIds": UmraDetails.bookedseatsidback,
          "TripID": UmraDetails.tripList.tripIdBack,
          "FromStationID": UmraDetails.tripList.fromStationIdBack,
          "ToStationID": UmraDetails.tripList.toStationIdBack,
          "TripDate": UmraDetails.tripList.tripDateBack.toString(),
          "Price": UmraDetails.afterdiscount / 2,
          "Discount": (UmraDetails.dicount / 2).toString(),
          "LineID": UmraDetails.tripList.lineIdBack,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdBack,
          "BusID": UmraDetails.tripList.busIdBack
        }
      ],
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "TripUmrahID": UmraDetails.tripList.tripUmraId,
      "PromoCodeID": UmraDetails.promocodid,
      "PaymentTypeID": paymentTypeID,
      "PaymentMethodID": PaymentMethodID
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
      "TripReservationList": [
        {
          "SeatIds": UmraDetails.bookedseatsidgo,
          "TripID": UmraDetails.tripList.tripGoId,
          "FromStationID": UmraDetails.tripList.fromStationIdGo,
          "ToStationID": UmraDetails.tripList.toStationIdGo,
          "TripDate": UmraDetails.tripList.tripDateGo.toString(),
          "Price": UmraDetails.afterdiscount / 2,
          "Discount": (UmraDetails.dicount / 2).toString(),
          "LineID": UmraDetails.tripList.lineIdGo,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdGo,
          "BusID": UmraDetails.tripList.busIdGo
        },
        {
          "SeatIds": UmraDetails.bookedseatsidback,
          "TripID": UmraDetails.tripList.tripIdBack,
          "FromStationID": UmraDetails.tripList.fromStationIdBack,
          "ToStationID": UmraDetails.tripList.toStationIdBack,
          "TripDate": UmraDetails.tripList.tripDateBack.toString(),
          "Price": UmraDetails.afterdiscount / 2,
          "Discount": (UmraDetails.dicount / 2).toString(),
          "LineID": UmraDetails.tripList.lineIdBack,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdBack,
          "BusID": UmraDetails.tripList.busIdBack
        }
      ],
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "TripUmrahID": UmraDetails.tripList.tripUmraId,
      "PromoCodeID": UmraDetails.promocodid,
      "PaymentTypeID": paymentTypeID,
      "PaymentMethodID": PaymentMethodID,
      "cardPaymentModel": {
        "CustomerId": Routes.customerid,
        "amount": UmraDetails.afterdiscount,
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

  Future fawrypayment({
    required int paymentTypeID,
    required int PaymentMethodID,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var data = json.encode({
      "TripReservationList": [
        {
          "SeatIds": UmraDetails.bookedseatsidgo,
          "TripID": UmraDetails.tripList.tripGoId,
          "FromStationID": UmraDetails.tripList.fromStationIdGo,
          "ToStationID": UmraDetails.tripList.toStationIdGo,
          "TripDate": UmraDetails.tripList.tripDateGo.toString(),
          "Price": UmraDetails.afterdiscount / 2,
          "Discount": (UmraDetails.dicount / 2).toString(),
          "LineID": UmraDetails.tripList.lineIdGo,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdGo,
          "BusID": UmraDetails.tripList.busIdGo
        },
        {
          "SeatIds": UmraDetails.bookedseatsidback,
          "TripID": UmraDetails.tripList.tripIdBack,
          "FromStationID": UmraDetails.tripList.fromStationIdBack,
          "ToStationID": UmraDetails.tripList.toStationIdBack,
          "TripDate": UmraDetails.tripList.tripDateBack.toString(),
          "Price": UmraDetails.afterdiscount / 2,
          "Discount": (UmraDetails.dicount / 2).toString(),
          "LineID": UmraDetails.tripList.lineIdBack,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdBack,
          "BusID": UmraDetails.tripList.busIdBack
        }
      ],
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "TripUmrahID": UmraDetails.tripList.tripUmraId,
      "PromoCodeID": UmraDetails.promocodid,
      "PaymentTypeID": paymentTypeID,
      "PaymentMethodID": PaymentMethodID,
      "RefNoModel": {
        "CustomerId": Routes.customerid,
        "Amount": UmraDetails.afterdiscount,
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

  Future getpolicy() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer
        .get("${EndPoints.baseUrl}TripUmra/PloicyTrip?countryID=$countryid");

    log("policy" + res.body);
    var decode = json.decode(res.body);
    Policyticketmodel linesModel = Policyticketmodel.fromJson(decode);
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
      "TripReservationList": [
        {
          "SeatIds": UmraDetails.bookedseatsidgo,
          "TripID": UmraDetails.tripList.tripGoId,
          "FromStationID": UmraDetails.tripList.fromStationIdGo,
          "ToStationID": UmraDetails.tripList.toStationIdGo,
          "TripDate": UmraDetails.tripList.tripDateGo.toString(),
          "Price": UmraDetails.afterdiscount / 2,
          "Discount": (UmraDetails.dicount / 2).toString(),
          "LineID": UmraDetails.tripList.lineIdGo,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdGo,
          "BusID": UmraDetails.tripList.busIdGo
        },
        {
          "SeatIds": UmraDetails.bookedseatsidback,
          "TripID": UmraDetails.tripList.tripIdBack,
          "FromStationID": UmraDetails.tripList.fromStationIdBack,
          "ToStationID": UmraDetails.tripList.toStationIdBack,
          "TripDate": UmraDetails.tripList.tripDateBack.toString(),
          "Price": UmraDetails.afterdiscount / 2,
          "Discount": (UmraDetails.dicount / 2).toString(),
          "LineID": UmraDetails.tripList.lineIdBack,
          "ServiceTypeID": UmraDetails.tripList.serviceTypeIdBack,
          "BusID": UmraDetails.tripList.busIdBack
        }
      ],
      "CustomerID": Routes.customerid,
      "CountryID": countryid,
      "TripUmrahID": UmraDetails.tripList.tripUmraId,
      "PromoCodeID": UmraDetails.promocodid,
      "PaymentTypeID": paymentTypeID,
      "PaymentMethodID": PaymentMethodID,
      "ewalletModel": {
        "customerId": Routes.customerid,
        "amount": UmraDetails.afterdiscount,
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
}
