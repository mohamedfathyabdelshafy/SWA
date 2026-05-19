// To parse this JSON data, do
//
//     final transportationListModel = transportationListModelFromJson(jsonString);

import 'dart:convert';

TransportationListModel transportationListModelFromJson(String str) =>
    TransportationListModel.fromJson(json.decode(str));

class TransportationListModel {
  String? status;
  Message? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  TransportationListModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory TransportationListModel.fromJson(Map<String, dynamic> json) =>
      TransportationListModel(
        status: json["status"],
        message: Message.fromJson(json["message"]),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );
}

class Message {
  List<TransportList>? transportList;
  List<TransportList>? transportSuggestedList;
  bool? isRequired;
  bool? sameSeatCount;

  Message(
      {this.transportList,
      this.transportSuggestedList,
      this.isRequired,
      this.sameSeatCount});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        transportList: List<TransportList>.from(
            json["TransportList"].map((x) => TransportList.fromJson(x))),
        transportSuggestedList: List<TransportList>.from(
            json["TransportSuggestedList"]
                .map((x) => TransportList.fromJson(x))),
        isRequired: json["IsRequired"],
        sameSeatCount: json["SameSeatCount"],
      );
}

class TransportList {
  int? tripUmraId;
  int? tripId;
  String? tripDate;
  dynamic priceSeat;
  dynamic notes;
  bool? isDelete;
  bool? isActive;
  int? availability;
  String? tripTime;
  String? to;
  String? from;
  int? lineId;
  int? busId;
  String? fromStationName;
  String? toStationName;
  int? serviceTypeId;
  bool? isreserved;
  int? personCountReserved;
  bool? isAddedTrip;
  dynamic fromStationId;
  dynamic toStationId;
  int? tripUmrahTransportationId;
  int? reservationId;

  TransportList({
    this.tripUmraId,
    this.tripId,
    this.tripDate,
    this.priceSeat,
    this.notes,
    this.isDelete,
    this.isActive,
    this.availability,
    this.tripTime,
    this.to,
    this.from,
    this.lineId,
    this.busId,
    this.fromStationName,
    this.toStationName,
    this.serviceTypeId,
    this.isreserved,
    this.personCountReserved,
    this.isAddedTrip,
    this.fromStationId,
    this.toStationId,
    this.tripUmrahTransportationId,
    this.reservationId,
  });

  factory TransportList.fromJson(Map<String, dynamic> json) => TransportList(
        tripUmraId: json["TripUmraID"],
        tripId: json["TripID"],
        tripDate: json["TripDate"],
        priceSeat: json["PriceSeat"],
        notes: json["Notes"],
        isDelete: json["IsDelete"],
        isActive: json["IsActive"],
        availability: json["Availability"],
        tripTime: json["TripTime"],
        to: json["To"],
        from: json["From"],
        lineId: json["LineID"],
        busId: json["BusID"],
        fromStationName: json["FromStationName"],
        toStationName: json["ToStationName"],
        serviceTypeId: json["ServiceTypeID"],
        isreserved: json["Isreserved"],
        personCountReserved: json["PersonCountReserved"],
        isAddedTrip: json["IsAddedTrip"],
        fromStationId: json["FromStationID"],
        toStationId: json["ToStationID"],
        tripUmrahTransportationId: json["TripUmrahTransportationID"],
        reservationId: json["ReservationID"],
      );

  Map<String, dynamic> toJson() => {
        "TripUmraID": tripUmraId,
        "TripID": tripId,
        "TripDate": tripDate,
        "PriceSeat": priceSeat,
        "Notes": notes,
        "IsDelete": isDelete,
        "IsActive": isActive,
        "Availability": availability,
        "TripTime": tripTime,
        "To": to,
        "From": from,
        "LineID": lineId,
        "BusID": busId,
        "FromStationName": fromStationName,
        "ToStationName": toStationName,
        "ServiceTypeID": serviceTypeId,
        "Isreserved": isreserved,
        "PersonCountReserved": personCountReserved,
        "IsAddedTrip": isAddedTrip,
        "FromStationID": fromStationId,
        "ToStationID": toStationId,
        "TripUmrahTransportationID": tripUmrahTransportationId,
        "ReservationID": reservationId,
      };
}
