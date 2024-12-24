// To parse this JSON data, do
//
//     final Seatsmodel = SeatsmodelFromJson(jsonString);

import 'dart:convert';

import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsModel.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';

Seatsmodel SeatsmodelFromJson(String str) =>
    Seatsmodel.fromJson(json.decode(str));

class Seatsmodel {
  String? status;
  Busdata? message;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Seatsmodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.obj,
  });

  factory Seatsmodel.fromJson(Map<String, dynamic> json) => Seatsmodel(
        status: json["status"],
        message: Busdata.fromJson(json["message"]),
        balance: json["balance"],
        object: json["Object"],
        obj: json["Obj"],
      );
}

class Busdata {
  BusDetailsVm? busDetailsVm;
  int? tripId;
  int? totalSeats;
  int? tripTypeId;
  String? tripTypeName;
  int? fromStationId;
  int? toStationId;
  DateTime? tripDate;
  String? lineName;
  int? lineId;
  int? busId;
  int? emptySeats;
  int? reservationId;
  double? seatPrice;
  List<int>? mySeatListId;

  Busdata({
    this.busDetailsVm,
    this.tripId,
    this.totalSeats,
    this.tripTypeId,
    this.tripTypeName,
    this.fromStationId,
    this.toStationId,
    this.tripDate,
    this.lineName,
    this.lineId,
    this.busId,
    this.emptySeats,
    this.reservationId,
    this.seatPrice,
    this.mySeatListId,
  });

  factory Busdata.fromJson(Map<String, dynamic> json) => Busdata(
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
        mySeatListId: json["MySeatListID"] == null
            ? []
            : List<int>.from(json["MySeatListID"].map((x) => x)),
      );
}

class BusDetailsVm {
  int? busId;
  int? totalRow;
  int? totalColumn;
  int? totalSeats;
  int? busDetailsId;
  List<RowLists>? rowList;

  BusDetailsVm({
    this.busId,
    this.totalRow,
    this.totalColumn,
    this.totalSeats,
    this.busDetailsId,
    this.rowList,
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
