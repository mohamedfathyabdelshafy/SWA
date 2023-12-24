class ResponseTicketHistoryModel {
  ResponseTicketHistoryModel({
      this.status, 
      this.message, 
      this.balance, 
      this.object, 
      this.obj,
  this.errorMassage});

  ResponseTicketHistoryModel.fromJson(dynamic json) {
    status = json['status'];
    if( json['status'] == "success"){
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message?.add(Message.fromJson(v));
      });
    }}else{
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (message != null) {
      map['message'] = message?.map((v) => v.toJson()).toList();
    }
    map['balance'] = balance;
    map['Object'] = object;
    map['Obj'] = obj;
    return map;
  }

}

class Message {
  Message({
      this.seatBusNo, 
      this.reservationID, 
      this.tripID, 
      this.lineName, 
      this.busID, 
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
      this.statusName, 
      this.reservationDate,});

  Message.fromJson(dynamic json) {
    seatBusNo = json['SeatBusNo'];
    reservationID = json['ReservationID'];
    tripID = json['TripID'];
    lineName = json['LineName'];
    busID = json['BusID'];
    plateNo = json['PlateNo'];
    status = json['Status'];
    from = json['From'];
    to = json['To'];
    creationDate = json['CreationDate'];
    price = json['Price'];
    seatNo = json['SeatNo'];
    seatNumberReserved = json['SeatNumberReserved'];
    ticketNumber = json['TicketNumber'];
    tripNumber = json['TripNumber'];
    fromStationID = json['FromStationID'];
    toStationID = json['ToStationID'];
    tripDate = json['TripDate'];
    accessBusTime = json['AccessBusTime'];
    tripType = json['TripType'];
    statusName = json['StatusName'];
    reservationDate = json['ReservationDate'] != null ? DateTime.parse(json["ReservationDate"]) : null;
  }
  int? seatBusNo;
  int? reservationID;
  int? tripID;
  String? lineName;
  int? busID;
  String? plateNo;
  dynamic status;
  String? from;
  String? to;
  String? creationDate;
  double? price;
  int? seatNo;
  int? seatNumberReserved;
  int? ticketNumber;
  int? tripNumber;
  int? fromStationID;
  int? toStationID;
  String? tripDate;
  String? accessBusTime;
  String? tripType;
  String? statusName;
  DateTime? reservationDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SeatBusNo'] = seatBusNo;
    map['ReservationID'] = reservationID;
    map['TripID'] = tripID;
    map['LineName'] = lineName;
    map['BusID'] = busID;
    map['PlateNo'] = plateNo;
    map['Status'] = status;
    map['From'] = from;
    map['To'] = to;
    map['CreationDate'] = creationDate;
    map['Price'] = price;
    map['SeatNo'] = seatNo;
    map['SeatNumberReserved'] = seatNumberReserved;
    map['TicketNumber'] = ticketNumber;
    map['TripNumber'] = tripNumber;
    map['FromStationID'] = fromStationID;
    map['ToStationID'] = toStationID;
    map['TripDate'] = tripDate;
    map['AccessBusTime'] = accessBusTime;
    map['TripType'] = tripType;
    map['StatusName'] = statusName;
    map['ReservationDate'] = reservationDate;
    return map;
  }

}