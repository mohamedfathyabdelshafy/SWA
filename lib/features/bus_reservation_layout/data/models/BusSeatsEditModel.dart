// To parse this JSON data, do
//
//     final busSeatsEditModel = busSeatsEditModelFromJson(jsonString);

import 'dart:convert';

import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsModel.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';

BusSeatsEditModel busSeatsEditModelFromJson(String str) =>
    BusSeatsEditModel.fromJson(json.decode(str));

class BusSeatsEditModel {
  String status;
  Message message;
  dynamic balance;
  dynamic object;
  dynamic obj;

  BusSeatsEditModel({
    required this.status,
    required this.message,
    required this.balance,
    required this.object,
    required this.obj,
  });

  factory BusSeatsEditModel.fromJson(Map<String, dynamic> json) =>
      BusSeatsEditModel(
        status: json["status"],
        message: Message.fromJson(json["message"]),
        balance: json["balance"],
        object: json["Object"],
        obj: json["Obj"],
      );
}

class Message {
  BusDetailsVm busDetailsVm;
  int tripId;
  int totalSeats;
  int tripTypeId;
  String tripTypeName;
  int fromStationId;
  int toStationId;
  DateTime tripDate;
  String lineName;
  int lineId;
  int busId;
  int emptySeats;
  int reservationId;
  double seatPrice;
  List<int> mySeatListId;

  Message({
    required this.busDetailsVm,
    required this.tripId,
    required this.totalSeats,
    required this.tripTypeId,
    required this.tripTypeName,
    required this.fromStationId,
    required this.toStationId,
    required this.tripDate,
    required this.lineName,
    required this.lineId,
    required this.busId,
    required this.emptySeats,
    required this.reservationId,
    required this.seatPrice,
    required this.mySeatListId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        busDetailsVm: BusDetailsVm.fromJson(json["BusDetailsVM"]),
        tripId: json["TripId"],
        totalSeats: json["TotalSeats"],
        tripTypeId: json["TripTypeID"],
        tripTypeName: json["TripTypeName"],
        fromStationId: json["FromStationID"],
        toStationId: json["ToStationID"],
        tripDate: DateTime.parse(json["TripDate"]),
        lineName: json["LineName"],
        lineId: json["LineID"],
        busId: json["BusId"],
        emptySeats: json["EmptySeats"],
        reservationId: json["ReservationID"],
        seatPrice: json["SeatPrice"],
        mySeatListId: List<int>.from(json["MySeatListID"].map((x) => x)),
      );
}

class BusDetailsVm {
  int busId;
  int totalRow;
  int totalColumn;
  int totalSeats;
  int busDetailsId;
  List<RowLists> rowList;

  BusDetailsVm({
    required this.busId,
    required this.totalRow,
    required this.totalColumn,
    required this.totalSeats,
    required this.busDetailsId,
    required this.rowList,
  });

  factory BusDetailsVm.fromJson(Map<String, dynamic> json) => BusDetailsVm(
        busId: json["BusID"],
        totalRow: json["TotalRow"],
        totalColumn: json["TotalColumn"],
        totalSeats: json["TotalSeats"],
        busDetailsId: json["BusDetailsID"],
        rowList: List<RowLists>.from(
            json["RowList"].map((x) => RowLists.fromJson(x))),
      );
}

class RowLists {
  RowLists({
    this.busDetailsID,
    this.busID,
    this.seats = const [],
  });

  RowLists.fromJson(dynamic json) {
    busDetailsID = json['BusDetailsID'];
    busID = json['BusID'];
    for (int i = 1; i <= 5; i++) {
      seats.add(SeatDetails(
          isAvailable: json['Column$i'],
          isReserved: json['IsReserved$i'],
          seatNo: json['SeatNo$i'],
          seatBusID: json['SeatBusID$i']));
    }
  }
  num? busDetailsID;
  num? busID;
  List<SeatDetails> seats = [];
}
