import '../../presentation/widgets/bus_seat_widget/seat_layout_model.dart';

class BusSeatsModel {
  BusSeatsModel({
      this.status, 
      this.busSeatDetails,
     });

  BusSeatsModel.fromJson(dynamic json) {
    status = json['status'];
    busSeatDetails = json['message'] != null ? BusSeatDetails.fromJson(json['message']) : null;

  }
  String? status;
  BusSeatDetails? busSeatDetails;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (BusSeatDetails != null) {
      map['message'] = busSeatDetails?.toJson();
    }

    return map;
  }

}

class BusSeatDetails {
  BusSeatDetails({
      this.busDetails,
      this.tripId, 
      this.totalSeats, 
      this.fromStationID, 
      this.toStationID, 
      this.tripDate, 
      this.busId, 
      this.emptySeats,});

  BusSeatDetails.fromJson(dynamic json) {
    busDetails = json['BusDetailsVM'] != null ? BusDetails.fromJson(json['BusDetailsVM']) : null;
    tripId = json['TripId'];
    totalSeats = json['TotalSeats'];
    fromStationID = json['FromStationID'];
    toStationID = json['ToStationID'];
    tripDate = json['TripDate'];
    busId = json['BusId'];
    emptySeats = json['EmptySeats'];
  }
  BusDetails? busDetails;
  int? tripId;
  int? totalSeats;
  int? fromStationID;
  int? toStationID;
  String? tripDate;
  int? busId;
  int? emptySeats;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (busDetails != null) {
      map['BusDetailsVM'] = busDetails?.toJson();
    }
    map['TripId'] = tripId;
    map['TotalSeats'] = totalSeats;
    map['FromStationID'] = fromStationID;
    map['ToStationID'] = toStationID;
    map['TripDate'] = tripDate;
    map['BusId'] = busId;
    map['EmptySeats'] = emptySeats;
    return map;
  }

}

class BusDetails{
  BusDetails({
      this.busID, 
      this.totalRow, 
      this.totalColumn, 
      this.totalSeats, 
      this.busDetailsID, 
      this.rowList,});

  BusDetails.fromJson(dynamic json) {
    busID = json['BusID'];
    totalRow = json['TotalRow'];
    totalColumn = json['TotalColumn'];
    totalSeats = json['TotalSeats'];
    busDetailsID = json['BusDetailsID'];
    if (json['RowList'] != null) {
      rowList = [];
      json['RowList'].forEach((v) {
        rowList?.add(RowList.fromJson(v));
      });
    }
  }
  int? busID;
  int? totalRow;
  int? totalColumn;
  int? totalSeats;
  int? busDetailsID;
  List<RowList>? rowList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BusID'] = busID;
    map['TotalRow'] = totalRow;
    map['TotalColumn'] = totalColumn;
    map['TotalSeats'] = totalSeats;
    map['BusDetailsID'] = busDetailsID;
    return map;
  }

}

class RowList {
  RowList({
    this.busDetailsID,
    this.busID,
    this.seats = const [],
  });

  RowList.fromJson(dynamic json) {
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

class SeatDetails {
  SeatDetails({
    this.isAvailable,
    this.seatNo,
    this.isReserved,
    this.seatBusID,
    this.isReservedBeforeFromStudent,
  }) {
    seatState = getSeatState;
  }
  bool? isAvailable;
  num? seatNo;
  bool? isReserved;
  bool? isReservedBeforeFromStudent;
  num? seatBusID;
  SeatState? seatState;

  SeatState get getSeatState {
    if (seatNo == 0) {
      return SeatState.empty;
    }
    if(isReserved == false && isAvailable == false){
      return SeatState.available;
    } else if (isAvailable == true) {
      return SeatState.available;
    }else if(isReserved == true ) {
      return SeatState.sold;
    }
    return SeatState.empty;
  }
}