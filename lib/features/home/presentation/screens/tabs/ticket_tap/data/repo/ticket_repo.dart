import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:swa/config/routes/app_routes.dart';

import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Reservation_Response_fawry_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Response_ticket_history_Model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Ticketdetails_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/editpolicy_model.dart';

class TicketRepo {
  final ApiConsumer apiConsumer;
  TicketRepo(this.apiConsumer);

  Future<ResponseTicketHistoryModel?> getTicketHistory(
      {required int customerId}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final response = await apiConsumer.get(
        "${EndPoints.baseUrl}Reservation/ReservationsHistory?customerId=$customerId&countryID=$countryid");

    log('ticketHistory response ' + response.body);
    var decodedResponse = json.decode(response.body);
    ResponseTicketHistoryModel responseTicketHistoryModel =
        ResponseTicketHistoryModel.fromJson(decodedResponse);
    return responseTicketHistoryModel;
  }

  Future<TicketdetailsModel?> getTicktdetails({required int tekitid}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "APIKey": "546548dwfdfsd3f4sdfhgat52",
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            "${EndPoints.baseUrl}Reservation/TicketDetail?reservationID=$tekitid"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(await response.stream.bytesToString());
      TicketdetailsModel responseTicketHistoryModel =
          TicketdetailsModel.fromJson(decodedResponse);
      return responseTicketHistoryModel;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future geteditpolicy() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "APIKey": "546548dwfdfsd3f4sdfhgat52",
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };

    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var request = http.Request(
        'GET',
        Uri.parse(
            "${EndPoints.baseUrl}Settings/PloicyCancelorEditTrip?countryID=$countryid"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(await response.stream.bytesToString());
      Editpolicymodel message = Editpolicymodel.fromJson(decodedResponse);
      return message;
    } else {
      print(response.reasonPhrase);
      return response.reasonPhrase;
    }
  }

  Future cancelticketfun({required int resrvationid}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "APIKey": "546548dwfdfsd3f4sdfhgat52",
      "Accept-Language": LanguageClass.isEnglish ? "en" : "ar"
    };

    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    var request = http.Request(
        'POST',
        Uri.parse(
            "${EndPoints.baseUrl}Reservation/CancelReserve?customerID=${Routes.customerid}&reservationID=$resrvationid&countryID=$countryid"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(await response.stream.bytesToString());
      ReservationResponseModel message =
          ReservationResponseModel.fromJson(decodedResponse);
      return message;
    } else {
      print(response.reasonPhrase);
      return response.reasonPhrase;
    }
  }

  Future Sendconfirmationcode({required String email}) async {
    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52'
    };
    var request = http.Request(
        'POST', Uri.parse('${EndPoints.baseUrl}Accounts/sendconfirmationcode'));
    request.body = json.encode({"Email": email});
    request.headers.addAll(headers);

    print(' body ' + request.body);

    http.StreamedResponse response = await request.send();
    var decodedResponse = json.decode(await response.stream.bytesToString());
    log(decodedResponse.toString());

    if (response.statusCode == 200) {
      ReservationResponseModel message =
          ReservationResponseModel.fromJson(decodedResponse);
      return message;
    } else {
      print(response.reasonPhrase);

      ReservationResponseModel message =
          ReservationResponseModel.fromJson(decodedResponse);
      return message;
    }
  }

  Future confirmemail({required String otp}) async {
    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52'
    };
    var request = http.Request(
        'POST', Uri.parse('${EndPoints.baseUrl}Accounts/confirmemail'));
    request.body = json.encode({"Email": Routes.emailaddress, "Code": otp});
    request.headers.addAll(headers);

    print(' body ' + request.body);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(await response.stream.bytesToString());

      log(decodedResponse.toString());
      ReservationResponseModel message =
          ReservationResponseModel.fromJson(decodedResponse);
      return message;
    } else {
      print(response.reasonPhrase);
      return response.reasonPhrase;
    }
  }
}
