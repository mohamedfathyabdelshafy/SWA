import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Response_ticket_history_Model.dart';

class TicketRepo {
  final ApiConsumer apiConsumer;
  TicketRepo(this.apiConsumer);

  Future<ResponseTicketHistoryModel?> getTicketHistory(
      {required int customerId}) async {
    final response = await apiConsumer.get(
        "${EndPoints.baseUrl}Customer/CustomerReservationsHistory?customerId=$customerId");
    log('ticketHistory response ' + response.body);
    var decodedResponse = json.decode(response.body);
    ResponseTicketHistoryModel responseTicketHistoryModel =
        ResponseTicketHistoryModel.fromJson(decodedResponse);
    return responseTicketHistoryModel;
  }
}
