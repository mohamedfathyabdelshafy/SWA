class ResponseTicketHistoryModel {
  ResponseTicketHistoryModel(
      {this.status,
      this.message,
      this.balance,
      this.object,
      this.obj,
      this.errorMassage});

  ResponseTicketHistoryModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['status'] == "success") {
      if (json['message'] != null) {
        message = [];
        json['message'].forEach((v) {
          message?.add(Message.fromJson(v));
        });
      }
    } else {
      errorMassage = json['message'];
    }
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
  String? status;
  List<Message>? message;
  String? errorMassage;
  dynamic balance;
  dynamic object;
  dynamic obj;
}

class Message {
  Message(
      {this.seatBusNo,
      this.reservationId,
      this.tripId,
      this.lineName,
      this.busId,
      this.plateNo,
      this.status,
      this.from,
      this.to,
      this.creationDate,
      this.price,
      this.seatNo,
      this.seatNumberReserved,
      this.ticketNumber,
      this.tripNumber,
      this.fromStationID,
      this.toStationID,
      this.tripDate,
      this.accessBusTime,
      this.tripType,
      this.seatNoList,
      this.statusName,
      this.isPaid,
      this.reservationDate,
      this.CanEditOrCancel,
      this.servecietype});

  Message.fromJson(dynamic json) {
    seatBusNo = json['SeatBusNo'];
    reservationId = json['ReservationID'];
    tripId = json['TripID'];
    lineName = json['LineName'];
    busId = json['BusID'];
    seatNoList = json['SeatNoList'];
    plateNo = json['PlateNo'];
    status = json['Status'];
    from = json['From'];
    to = json['To'];
    creationDate = DateTime.parse(json["CreationDate"]);
    price = json['Price'];
    seatNo = json['SeatNo'];
    seatNumberReserved = json['SeatNumberReserved'];
    ticketNumber = json['TicketNumber'];
    tripNumber = json['TripNumber'];
    fromStationID = json['FromStationID'];
    toStationID = json['ToStationID'];
    servecietype = json['ServiceType'] ?? '';
    tripDate = DateTime.parse(json["TripDate"]);
    accessBusTime = json['AccessBusTime'];
    tripType = json['TripType'];
    statusName = json['StatusName'];
    reservationDate = DateTime.parse(json["ReservationDate"]);
    isPaid = json["IsPaid"];
    CanEditOrCancel = json['CanEditOrCancel'];
  }
  String? phoneNumber;
  String? customerName;
  dynamic seatBusNo;
  int? reservationId;
  int? tripId;
  String? lineName;
  int? busId;
  String? plateNo;
  int? status;
  String? from;
  String? to;
  DateTime? creationDate;
  double? price;
  dynamic seatNo;
  dynamic seatNumberReserved;
  int? ticketNumber;
  int? tripNumber;
  int? fromStationID;
  int? toStationID;
  DateTime? tripDate;
  String? accessBusTime;
  String? tripType;
  String? statusName;
  DateTime? reservationDate;
  List? seatNoList;
  int? countryId;
  String? servecietype;
  bool? isPaid;
  bool? CanEditOrCancel;
}
