import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/home/data/models/Ads_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/ActivePackage_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/Ads_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/Select_appmodel.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/packages_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/station_from_model.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Electronic_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_response_MyWallet_model.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';

import '../../../data/model/promocode_model.dart';

class PackagesRespo {
  final ApiConsumer apiConsumer = sl();

  Future getstationfrom() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}Stations/GetSationListFrom?countryID=$countryid");

    log(" station from" + response.body);
    var decode = json.decode(response.body);
    StationfromModel linesModel = StationfromModel.fromJson(decode);
    return linesModel;
  }

  Future checkversion() async {
    try {
      GooglePlayServicesAvailability availability = await GoogleApiAvailability
          .instance
          .checkGooglePlayServicesAvailability();

      log(availability.toString());

      //17 android 18 ios 19 huawei
      String typeID = Platform.isIOS
          ? "18"
          : availability == GooglePlayServicesAvailability.success
              ? "17"
              : "19";
      String version = Platform.isIOS
          ? EndPoints.iosVersion
          : availability == GooglePlayServicesAvailability.success
              ? EndPoints.playStoreVersion
              : EndPoints.huaweiVersion;

      var response = await apiConsumer.get(
          "${EndPoints.baseUrl}UpdateVersions/CheckVersion?typeID=$typeID&version=$version");
      log("${EndPoints.baseUrl}UpdateVersions/CheckVersion?typeID=$typeID&version=$version");

      log(" response" + response.body);
      var decode = json.decode(response.body);

      log('Ahmed ' + decode['status']);

      return decode['status'];
    } catch (e) {
      log(e.toString());
      return 'failed';
    }
  }

  Future getstationto({required String stationid}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}Stations/GetSationListTo?stationId=$stationid&countryID=$countryid");

    log(" station from" + response.body);
    var decode = json.decode(response.body);
    StationfromModel linesModel = StationfromModel.fromJson(decode);
    return linesModel;
  }

  Future selectapp() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var response = await apiConsumer
        .get("${EndPoints.baseUrl}Settings/GetMainPage?countryID=$countryid");

    log(" Select app" + response.body);
    var decode = json.decode(response.body);
    Selectappmodel linesModel = Selectappmodel.fromJson(decode);
    return linesModel;
  }

  Future getpackages({required String stationfromid, stationtoid}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}Package/GetPackages?fromID=$stationfromid&toID=$stationtoid&countryID=$countryid");

    log("packges" + response.body);
    var decode = json.decode(response.body);
    Packagemodel linesModel = Packagemodel.fromJson(decode);
    return linesModel;
  }

  Future getactivepackages() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var response = await apiConsumer.get(
      "${EndPoints.baseUrl}Package/ActivePackage?customerID=${Routes.customerid}&countryID=$countryid",
    );

    log("packges" + response.body);
    var decode = json.decode(response.body);
    ActivePackagemodel linesModel = ActivePackagemodel.fromJson(decode);
    return linesModel;
  }

  Future getads() async {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        1;

    var response = await apiConsumer.get(
      "${EndPoints.baseUrl}GetAds/GetAds?countryID=$countryid",
    );

    log("responce adv " + response.body.toString());
    var decode = json.decode(response.body);
    AdsModel linesModel = AdsModel.fromJson(decode);
    return linesModel;
  }

  Future getadsfunc() async {
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}ADCustomerAppWebView/GetAds?CustomerID=${Routes.customerid}");

    log('Atvertisment' + response.body);
    var decodedResponse = json.decode(response.body);
    AdvModel advModel = AdvModel.fromJson(decodedResponse);
    return advModel;
  }

  Future closeadsfunc({int? id}) async {
    log("${EndPoints.baseUrl}ADCustomerAppWebView/UpdateAds?CustomerID=${Routes.customerid}&ADCustomerAppWebViewID=$id");

    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}ADCustomerAppWebView/UpdateAds?CustomerID=${Routes.customerid}&ADCustomerAppWebViewID=$id");

    var decodedResponse = json.decode(response.body);
    var jsonDecode = json.decode(response.body);
    return jsonDecode;
  }

  Future promocode({required String code, packageid}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}Package/CheckPromoCode?customerID=${Routes.customerid}&promoCode=$code&countryID=$countryid&packageID=$packageid");

    log("packges" + response.body);
    var decode = json.decode(response.body);
    Promocodemodel linesModel = Promocodemodel.fromJson(decode);
    return linesModel;
  }

  Future promocodeRecervation({
    required String code,
    required int custId,
    required int paymentTypeID,
    required String promoid,
    required List<TripReservationList> trips,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var response = await apiConsumer.post(
      EndPoints.checkpromocode,
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
            "BusID": trips[0].busId,
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
        "PromoCode": code,
        "PaymentTypeID": paymentTypeID,
        "toCurrency": Routes.curruncy,
        "dateTypeID": UmraDetails.dateTypeID
      }),
    );
    log('body ' + response.request.body);

    log("discount " + response.body);
    var decode = json.decode(response.body);
    Promocodemodel linesModel = Promocodemodel.fromJson(decode);
    return linesModel;
  }

  Future packagepaywallet({
    required String packageid,
    required String promocodeid,
    String? paymentMethodID,
    required int paymentTypeID,
    required String amount,
    required String fromStationID,
    required String toStationId,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52',
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}/Package/SubscribePackage?customerID=${Routes.customerid}&countryID=$countryid'));
    request.body = json.encode({
      "CustomerID": Routes.customerid,
      "FromStationID": fromStationID,
      "ToStationID": toStationId,
      "PackageID": packageid,
      "PromoCodeID": promocodeid,
      "PaymentTypeID": paymentTypeID,
      "Amount": amount,
      "PaymentMethodID": paymentMethodID,
      "CountryID": countryid,
      "PackagePriceID": packageid,
      "cardPaymentModel": null,
      "ewalletModel": null,
      "refNoModel": null
    });
    request.headers.addAll(headers);
    log(request.body);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonresponse = jsonDecode(await response.stream.bytesToString());

      return ReservationResponseMyWalletModel.fromJson(jsonresponse);
    } else {
      log(await response.stream.bytesToString());
    }
  }

  Future packagespaycard({
    required String packageid,
    String? paymentMethodID,
    required int paymentTypeID,
    required double amount,
    required String fromStationID,
    required String toStationId,
    required String cardNumber,
    required String cardExpiryYear,
    required String cvv,
    required String cardExpiryMonth,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52',
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}Package/SubscribePackage?customerID=${Routes.customerid}&countryID=${countryid}'));
    request.body = json.encode({
      "CustomerID": Routes.customerid,
      "FromStationID": fromStationID,
      "ToStationID": toStationId,
      "PackageID": packageid,
      "PromoCodeID": Routes.PromoCodeID,
      "PaymentTypeID": paymentTypeID,
      "Amount": amount,
      "PaymentMethodID": paymentMethodID,
      "CountryID": countryid,
      "PackagePriceID": packageid,
      "cardPaymentModel": {
        "CustomerId": Routes.customerid,
        "amount": NumberFormat("###.00#", "en_US").format(amount),
        "cardNumber": cardNumber,
        "cardExpiryYear": cardExpiryYear,
        "cardExpiryMonth": cardExpiryMonth,
        "cvv": cvv,
      },
      "ewalletModel": null,
      "refNoModel": null
    });
    request.headers.addAll(headers);

    log(await request.toString());

    log(await request.body);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonresponse = jsonDecode(await response.stream.bytesToString());
      log(jsonresponse.toString());

      return ReservationResponseCreditCard.fromJson(jsonresponse);
    } else {
      log(await response.stream.bytesToString());
    }
  }

  Future fawrypay({
    required String packageid,
    String? paymentMethodID,
    required int paymentTypeID,
    required double amount,
    required String fromStationID,
    required String toStationId,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52',
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}Package/SubscribePackage?customerID=${Routes.customerid}&countryID=${countryid}'));
    request.body = json.encode({
      "CustomerID": Routes.customerid,
      "FromStationID": fromStationID,
      "ToStationID": toStationId,
      "PackageID": packageid,
      "PromoCodeID": Routes.PromoCodeID,
      "PaymentTypeID": paymentTypeID,
      "Amount": amount,
      "PaymentMethodID": paymentMethodID,
      "CountryID": countryid,
      "PackagePriceID": packageid,
      "ewalletModel": null,
      "cardPaymentModel": null,
      "refNoModel": {
        "CustomerId": Routes.customerid,
        "amount": NumberFormat("###.00#", "en_US").format(amount),
      },
    });
    request.headers.addAll(headers);

    log(await request.toString());

    log(await request.body);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonresponse = jsonDecode(await response.stream.bytesToString());
      log(jsonresponse.toString());

      return ReservationResponseElectronicModel.fromJson(jsonresponse);
    } else {
      log(await response.stream.bytesToString());
    }
  }

  Future electronicpay({
    required String packageid,
    String? paymentMethodID,
    required int paymentTypeID,
    required double amount,
    required String fromStationID,
    required String toStationId,
    required String mobile,
  }) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52',
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };
    log('a7a');

    var request = http.Request(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}Package/SubscribePackage?customerID=${Routes.customerid}&countryID=${countryid}'));
    request.body = json.encode({
      "CustomerID": Routes.customerid,
      "FromStationID": fromStationID,
      "ToStationID": toStationId,
      "PackageID": packageid,
      "PromoCodeID": Routes.PromoCodeID,
      "PaymentTypeID": paymentTypeID,
      "Amount": amount,
      "PaymentMethodID": paymentMethodID,
      "CountryID": countryid,
      "PackagePriceID": packageid,
      "cardPaymentModel": null,
      "ewalletModel": {
        "customerId": Routes.customerid,
        "amount": NumberFormat("###.00#", "en_US").format(amount),
        "mobile": mobile,
      },
      "refNoModel": null
    });
    request.headers.addAll(headers);
    log(await request.toString());

    log(await request.body);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonresponse = jsonDecode(await response.stream.bytesToString());
      log(jsonresponse.toString());

      return ReservationResponseElectronicModel.fromJson(jsonresponse);
    } else {
      log(await response.stream.bytesToString());
    }
  }

  Future GetallCurrency() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52',
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };
    log('a7a');

    var request = http.Request(
        'GET', Uri.parse('${EndPoints.baseUrl}Currency/GetAllCurrency'));
    request.headers.addAll(headers);
    log(await request.toString());

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonresponse = jsonDecode(await response.stream.bytesToString());
      log(jsonresponse.toString());

      return Curruncylist.fromJson(jsonresponse);
    } else {
      log(await response.stream.bytesToString());
    }
  }

  Future Convertcurrency({String? from, String? to, double? amount}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52',
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };

    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}Currency/GetExchnageRate?fromCurrency=$from&toCurrency=$to&amount=$amount'));
    request.headers.addAll(headers);
    log(await request.toString());

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonresponse = jsonDecode(await response.stream.bytesToString());
      log(jsonresponse.toString());

      return jsonresponse['message'];
    } else {
      log(await response.stream.bytesToString());
    }
  }
}
