// To parse this JSON data, do
//
//     final ticketdetailsModel = ticketdetailsModelFromJson(jsonString);

import 'dart:convert';

TicketdetailsModel ticketdetailsModelFromJson(String str) =>
    TicketdetailsModel.fromJson(json.decode(str));

class TicketdetailsModel {
  String? status;
  Message? message;
  String? errorMassage;

  dynamic balance;
  dynamic object;
  dynamic obj;

  TicketdetailsModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.obj,
  });

  TicketdetailsModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['status'] == "success") {
      message = Message.fromJson(json["message"]);
    } else {
      errorMassage = json['message'];
    }
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
}

class Message {
  int? reservationId;
  String? customerName;
  String? customerPhone;
  dynamic? description;
  int? tripId;
  int? busId;
  int? status;
  String? createdBy;
  String? creationDate;
  dynamic? organizationId;
  double? price;
  double? penalty;
  double? returnPrice;
  int? seatNo;
  String? plateNo;
  String? accessBusTime;
  String? lineName;
  int? maxCityOrder;
  String? from;
  String? to;
  int? fromStationId;
  int? toStationId;
  String? tripDate;
  String? tripType;
  bool? cancelled;
  String? serviceType;
  String? tripNumber;
  String? ticketNumber;
  dynamic? qrCode;
  String? seatNumbers;
  List<String>? policy;
  String? statusName;

  Message({
    this.reservationId,
    this.customerName,
    this.customerPhone,
    this.statusName,
    this.description,
    this.tripId,
    this.busId,
    this.status,
    this.createdBy,
    this.creationDate,
    this.organizationId,
    this.price,
    this.penalty,
    this.returnPrice,
    this.seatNo,
    this.plateNo,
    this.accessBusTime,
    this.lineName,
    this.maxCityOrder,
    this.from,
    this.to,
    this.fromStationId,
    this.toStationId,
    this.tripDate,
    this.tripType,
    this.cancelled,
    this.serviceType,
    this.tripNumber,
    this.ticketNumber,
    this.qrCode,
    this.seatNumbers,
    this.policy,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        reservationId: json["ReservationID"],
        customerName: json["CustomerName"],
        customerPhone: json["CustomerPhone"],
        description: json["Description"],
        tripId: json["TripID"],
        busId: json["BusID"],
        status: json["Status"],
        createdBy: json["CreatedBy"],
        creationDate: json["CreationDate"],
        organizationId: json["OrganizationID"],
        price: json["Price"],
        statusName: json['StatusName'],
        penalty: json["Penalty"],
        returnPrice: json["ReturnPrice"],
        seatNo: json["SeatNo"],
        plateNo: json["PlateNo"],
        accessBusTime: json["AccessBusTime"],
        lineName: json["LineName"],
        maxCityOrder: json["MaxCityOrder"],
        from: json["From"],
        to: json["To"],
        fromStationId: json["FromStationID"],
        toStationId: json["ToStationID"],
        tripDate: json["TripDate"],
        tripType: json["TripType"],
        cancelled: json["Cancelled"],
        serviceType: json["ServiceType"],
        tripNumber: json["TripNumber"],
        ticketNumber: json["TicketNumber"],
        qrCode: json["QrCode"],
        seatNumbers: json["SeatNumbers"],
        policy: List<String>.from(json["Policy"].map((x) => x)),
      );
}
