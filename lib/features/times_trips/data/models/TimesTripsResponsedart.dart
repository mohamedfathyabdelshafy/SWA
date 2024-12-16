// To parse this JSON data, do
//
//     final timesTripsResponse = timesTripsResponseFromJson(jsonString);

import 'dart:convert';

TimesTripsResponse timesTripsResponseFromJson(String str) =>
    TimesTripsResponse.fromJson(json.decode(str));

class TimesTripsResponse {
  String? status;
  Message? message;

  String? failureMessage;
  dynamic balance;
  dynamic object;
  dynamic obj;

  TimesTripsResponse({
    required this.status,
    this.message,
    this.failureMessage,
    this.balance,
    this.object,
    this.obj,
  });

  TimesTripsResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];

    if (json["status"] == 'success') {
      message = Message.fromJson(json["message"]);
    } else {
      failureMessage = json['message'];
    }

    message = Message.fromJson(json["message"]);
    balance = json["balance"];
    object = json["Object"];
    obj = json["Obj"];
  }
}

class Message {
  List<TripList> tripList;
  List<TripList> tripListBack;
  dynamic fromStationIdGo;
  dynamic toStationIdGo;
  dynamic tripDateGo;
  dynamic fromStationIdBack;
  dynamic toStationIdBack;
  dynamic tripDateBack;

  Message({
    required this.tripList,
    required this.tripListBack,
    required this.fromStationIdGo,
    required this.toStationIdGo,
    required this.tripDateGo,
    required this.fromStationIdBack,
    required this.toStationIdBack,
    required this.tripDateBack,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        tripList: List<TripList>.from(
            json["TripList"].map((x) => TripList.fromJson(x))),
        tripListBack: List<TripList>.from(
            json["TripListBack"].map((x) => TripList.fromJson(x))),
        fromStationIdGo: json["FromStationIDGo"],
        toStationIdGo: json["ToStationIDGo"],
        tripDateGo: json["TripDateGo"],
        fromStationIdBack: json["FromStationIDBack"],
        toStationIdBack: json["ToStationIDBack"],
        tripDateBack: json["TripDateBack"],
      );

  Map<String, dynamic> toJson() => {
        "TripList": List<dynamic>.from(tripList.map((x) => x.toJson())),
        "TripListBack": List<dynamic>.from(tripListBack.map((x) => x.toJson())),
        "FromStationIDGo": fromStationIdGo,
        "ToStationIDGo": toStationIdGo,
        "TripDateGo": tripDateGo,
        "FromStationIDBack": fromStationIdBack,
        "ToStationIDBack": toStationIdBack,
        "TripDateBack": tripDateBack,
      };
}

class TripList {
  int tripId;
  String accessBusTime;
  int busId;
  dynamic busModel;
  String busType;
  dynamic driverId;
  dynamic createdBy;
  dynamic creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  bool isDeleted;
  bool isStartedByDriver;
  bool isEndedByDriver;
  dynamic startTime;
  dynamic endTime;
  int tripTypeId;
  int lineId;
  dynamic organizationId;
  DateTime accessDate;
  bool isActive;
  dynamic busSupervisorId;
  dynamic busSupervisorManagerId;
  dynamic officeId;
  dynamic isMoved;
  dynamic moveTime;
  dynamic confirmFromDriver;
  int applyNoofDays;
  String plateNo;
  String tripType;
  String lineName;
  dynamic maxStationOrder;
  dynamic maxCityOrder;
  String from;
  String to;
  dynamic toCityName;
  dynamic fromCityName;
  dynamic day;
  int serviceTypeId;
  String serviceType;
  int emptySeat;
  dynamic price;
  List<dynamic> busList;
  List<dynamic> tripTypeList;
  List<dynamic> lineList;
  List<dynamic> serviceList;
  int tripNumber;
  dynamic priceAfterDiscount;
  dynamic pickupTime;
  dynamic arrivalTime;
  List<LineCity> lineCity;
  String timeOfCustomerStation;
  bool isArabic;

  TripList({
    required this.tripId,
    required this.accessBusTime,
    required this.busId,
    required this.busModel,
    required this.busType,
    required this.driverId,
    required this.createdBy,
    required this.creationDate,
    required this.updatedBy,
    required this.updateDate,
    required this.isDeleted,
    required this.isStartedByDriver,
    required this.isEndedByDriver,
    required this.startTime,
    required this.endTime,
    required this.tripTypeId,
    required this.lineId,
    required this.organizationId,
    required this.accessDate,
    required this.isActive,
    required this.busSupervisorId,
    required this.busSupervisorManagerId,
    required this.officeId,
    required this.isMoved,
    required this.moveTime,
    required this.confirmFromDriver,
    required this.applyNoofDays,
    required this.plateNo,
    required this.tripType,
    required this.lineName,
    required this.maxStationOrder,
    required this.maxCityOrder,
    required this.from,
    required this.to,
    required this.toCityName,
    required this.fromCityName,
    required this.day,
    required this.serviceTypeId,
    required this.serviceType,
    required this.emptySeat,
    required this.price,
    required this.busList,
    required this.tripTypeList,
    required this.lineList,
    required this.serviceList,
    required this.tripNumber,
    required this.priceAfterDiscount,
    required this.pickupTime,
    required this.arrivalTime,
    required this.lineCity,
    required this.timeOfCustomerStation,
    required this.isArabic,
  });

  factory TripList.fromJson(Map<String, dynamic> json) => TripList(
        tripId: json["TripId"],
        accessBusTime: json["AccessBusTime"],
        busId: json["BusId"],
        busModel: json["BusModel"],
        busType: json["BusType"],
        driverId: json["DriverId"],
        createdBy: json["CreatedBy"],
        creationDate: json["CreationDate"],
        updatedBy: json["UpdatedBy"],
        updateDate: json["UpdateDate"],
        isDeleted: json["IsDeleted"],
        isStartedByDriver: json["IsStartedByDriver"],
        isEndedByDriver: json["IsEndedByDriver"],
        startTime: json["StartTime"],
        endTime: json["EndTime"],
        tripTypeId: json["TripTypeId"],
        lineId: json["LineId"],
        organizationId: json["OrganizationId"],
        accessDate: DateTime.parse(json["AccessDate"]),
        isActive: json["IsActive"],
        busSupervisorId: json["BusSupervisorId"],
        busSupervisorManagerId: json["BusSupervisorManagerId"],
        officeId: json["OfficeID"],
        isMoved: json["IsMoved"],
        moveTime: json["MoveTime"],
        confirmFromDriver: json["ConfirmFromDriver"],
        applyNoofDays: json["ApplyNoofDays"],
        plateNo: json["PlateNo"],
        tripType: json["TripType"],
        lineName: json["LineName"]!,
        maxStationOrder: json["MaxStationOrder"],
        maxCityOrder: json["MaxCityOrder"],
        from: json["From"],
        to: json["To"],
        toCityName: json["ToCityName"],
        fromCityName: json["FromCityName"],
        day: json["Day"],
        serviceTypeId: json["ServiceTypeID"],
        serviceType: json["ServiceType"],
        emptySeat: json["EmptySeat"],
        price: json["Price"],
        busList: List<dynamic>.from(json["BusList"].map((x) => x)),
        tripTypeList: List<dynamic>.from(json["TripTypeList"].map((x) => x)),
        lineList: List<dynamic>.from(json["LineList"].map((x) => x)),
        serviceList: List<dynamic>.from(json["ServiceList"].map((x) => x)),
        tripNumber: json["TripNumber"],
        priceAfterDiscount: json["PriceAfterDiscount"],
        pickupTime: json["PickupTime"],
        arrivalTime: json["ArrivalTime"],
        lineCity: List<LineCity>.from(
            json["LineCity"].map((x) => LineCity.fromJson(x))),
        timeOfCustomerStation: json["TimeOfCustomerStation"],
        isArabic: json["IsArabic"],
      );

  Map<String, dynamic> toJson() => {
        "TripId": tripId,
        "AccessBusTime": accessBusTime,
        "BusId": busId,
        "BusModel": busModel,
        "BusType": busType,
        "DriverId": driverId,
        "CreatedBy": createdBy,
        "CreationDate": creationDate,
        "UpdatedBy": updatedBy,
        "UpdateDate": updateDate,
        "IsDeleted": isDeleted,
        "IsStartedByDriver": isStartedByDriver,
        "IsEndedByDriver": isEndedByDriver,
        "StartTime": startTime,
        "EndTime": endTime,
        "TripTypeId": tripTypeId,
        "LineId": lineId,
        "OrganizationId": organizationId,
        "AccessDate": accessDate.toIso8601String(),
        "IsActive": isActive,
        "BusSupervisorId": busSupervisorId,
        "BusSupervisorManagerId": busSupervisorManagerId,
        "OfficeID": officeId,
        "IsMoved": isMoved,
        "MoveTime": moveTime,
        "ConfirmFromDriver": confirmFromDriver,
        "ApplyNoofDays": applyNoofDays,
        "PlateNo": plateNo,
        "TripType": tripType,
        "LineName": lineName,
        "MaxStationOrder": maxStationOrder,
        "MaxCityOrder": maxCityOrder,
        "From": from,
        "To": to,
        "ToCityName": toCityName,
        "FromCityName": fromCityName,
        "Day": day,
        "ServiceTypeID": serviceTypeId,
        "ServiceType": serviceType,
        "EmptySeat": emptySeat,
        "Price": price,
        "BusList": List<dynamic>.from(busList.map((x) => x)),
        "TripTypeList": List<dynamic>.from(tripTypeList.map((x) => x)),
        "LineList": List<dynamic>.from(lineList.map((x) => x)),
        "ServiceList": List<dynamic>.from(serviceList.map((x) => x)),
        "TripNumber": tripNumber,
        "PriceAfterDiscount": priceAfterDiscount,
        "PickupTime": pickupTime,
        "ArrivalTime": arrivalTime,
        "LineCity": List<dynamic>.from(lineCity.map((x) => x.toJson())),
        "TimeOfCustomerStation": timeOfCustomerStation,
        "IsArabic": isArabic,
      };
}

class LineCity {
  int lineCityId;
  int cityId;
  int? orderIndex;
  dynamic createdBy;
  DateTime creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  bool isDelete;
  bool isActive;
  List<LineStationList> lineStationList;
  int governorateId;
  int lineId;
  String lineName;
  dynamic stationIdList;
  List<dynamic> stationList;
  String cityName;
  dynamic lineType;
  String governorateName;
  bool isArabic;

  LineCity({
    required this.lineCityId,
    required this.cityId,
    required this.orderIndex,
    required this.createdBy,
    required this.creationDate,
    required this.updatedBy,
    required this.updateDate,
    required this.isDelete,
    required this.isActive,
    required this.lineStationList,
    required this.governorateId,
    required this.lineId,
    required this.lineName,
    required this.stationIdList,
    required this.stationList,
    required this.cityName,
    required this.lineType,
    required this.governorateName,
    required this.isArabic,
  });

  factory LineCity.fromJson(Map<String, dynamic> json) => LineCity(
        lineCityId: json["LineCityID"],
        cityId: json["CityID"],
        orderIndex: json["OrderIndex"],
        createdBy: json["CreatedBy"],
        creationDate: DateTime.parse(json["CreationDate"]),
        updatedBy: json["UpdatedBy"],
        updateDate: json["UpdateDate"],
        isDelete: json["IsDelete"],
        isActive: json["IsActive"],
        lineStationList: List<LineStationList>.from(
            json["LineStationList"].map((x) => LineStationList.fromJson(x))),
        governorateId: json["GovernorateID"],
        lineId: json["LineID"],
        lineName: json["LineName"],
        stationIdList: json["StationIDList"],
        stationList: List<dynamic>.from(json["StationList"].map((x) => x)),
        cityName: json["CityName"],
        lineType: json["LineType"],
        governorateName: json["GovernorateName"],
        isArabic: json["IsArabic"],
      );

  Map<String, dynamic> toJson() => {
        "LineCityID": lineCityId,
        "CityID": cityId,
        "OrderIndex": orderIndex,
        "CreatedBy": createdBy,
        "CreationDate": creationDate.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdateDate": updateDate,
        "IsDelete": isDelete,
        "IsActive": isActive,
        "LineStationList":
            List<dynamic>.from(lineStationList.map((x) => x.toJson())),
        "GovernorateID": governorateId,
        "LineID": lineId,
        "LineName": lineName,
        "StationIDList": stationIdList,
        "StationList": List<dynamic>.from(stationList.map((x) => x)),
        "CityName": cityName,
        "LineType": lineType,
        "GovernorateName": governorateName,
        "IsArabic": isArabic,
      };
}

class LineStationList {
  int lineCityStationId;
  int stationId;
  dynamic accessPoinName;
  int? orderIndex;
  dynamic createdBy;
  DateTime creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  bool isDelete;
  bool isActive;
  int lineCityId;
  int lineId;
  String cityName;
  String lineName;
  String stationName;
  int afterMinuts;
  String accessTime;
  bool isArabic;

  LineStationList({
    required this.lineCityStationId,
    required this.stationId,
    required this.accessPoinName,
    required this.orderIndex,
    required this.createdBy,
    required this.creationDate,
    required this.updatedBy,
    required this.updateDate,
    required this.isDelete,
    required this.isActive,
    required this.lineCityId,
    required this.lineId,
    required this.cityName,
    required this.lineName,
    required this.stationName,
    required this.afterMinuts,
    required this.accessTime,
    required this.isArabic,
  });

  factory LineStationList.fromJson(Map<String, dynamic> json) =>
      LineStationList(
        lineCityStationId: json["LineCityStationID"],
        stationId: json["StationID"],
        accessPoinName: json["AccessPoinName"],
        orderIndex: json["OrderIndex"],
        createdBy: json["CreatedBy"],
        creationDate: DateTime.parse(json["CreationDate"]),
        updatedBy: json["UpdatedBy"],
        updateDate: json["UpdateDate"],
        isDelete: json["IsDelete"],
        isActive: json["IsActive"],
        lineCityId: json["LineCityID"],
        lineId: json["LineID"],
        cityName: json["CityName"],
        lineName: json["LineName"],
        stationName: json["StationName"],
        afterMinuts: json["AfterMinuts"],
        accessTime: json["AccessTime"],
        isArabic: json["IsArabic"],
      );

  Map<String, dynamic> toJson() => {
        "LineCityStationID": lineCityStationId,
        "StationID": stationId,
        "AccessPoinName": accessPoinName,
        "OrderIndex": orderIndex,
        "CreatedBy": createdBy,
        "CreationDate": creationDate.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdateDate": updateDate,
        "IsDelete": isDelete,
        "IsActive": isActive,
        "LineCityID": lineCityId,
        "LineID": lineId,
        "CityName": cityName,
        "LineName": lineName,
        "StationName": stationName,
        "AfterMinuts": afterMinuts,
        "AccessTime": accessTime,
        "IsArabic": isArabic,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
