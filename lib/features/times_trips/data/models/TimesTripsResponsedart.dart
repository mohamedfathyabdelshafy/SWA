class TimesTripsResponse {
  TimesTripsResponse({this.status, this.message, this.failureMessage});

  TimesTripsResponse.fromJson(dynamic json) {
    status = json['status'];
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
  String? status;
  Message? message;
  String? failureMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (message != null) {
      map['message'] = message?.toJson();
    }
    return map;
  }
}

class Message {
  Message({
    this.tripList,
    this.tripListBack,
    this.fromStationIDGo,
    this.toStationIDGo,
    this.tripDateGo,
    this.fromStationIDBack,
    this.toStationIDBack,
    this.tripDateBack,
  });

  Message.fromJson(dynamic json) {
    if (json['TripList'] != null) {
      tripList = [];
      json['TripList'].forEach((v) {
        tripList?.add(TripList.fromJson(v));
      });
    }
    if (json['TripListBack'] != null) {
      tripListBack = [];
      json['TripListBack'].forEach((v) {
        tripListBack?.add(TripListBack.fromJson(v));
      });
    }
    fromStationIDGo = json['FromStationIDGo'];
    toStationIDGo = json['ToStationIDGo'];
    tripDateGo = json['TripDateGo'];
    fromStationIDBack = json['FromStationIDBack'];
    toStationIDBack = json['ToStationIDBack'];
    tripDateBack = json['TripDateBack'];
  }
  List<TripList>? tripList;
  List<TripListBack>? tripListBack;
  int? fromStationIDGo;
  int? toStationIDGo;
  String? tripDateGo;
  int? fromStationIDBack;
  int? toStationIDBack;
  String? tripDateBack;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (tripList != null) {
      map['TripList'] = tripList?.map((v) => v.toJson()).toList();
    }
    if (tripListBack != null) {
      map['TripListBack'] = tripListBack?.map((v) => v.toJson()).toList();
    }
    map['FromStationIDGo'] = fromStationIDGo;
    map['ToStationIDGo'] = toStationIDGo;
    map['TripDateGo'] = tripDateGo;
    map['FromStationIDBack'] = fromStationIDBack;
    map['ToStationIDBack'] = toStationIDBack;
    map['TripDateBack'] = tripDateBack;
    return map;
  }
}

class TripListBack {
  TripListBack({
    this.tripId,
    this.accessBusTime,
    this.busId,
    this.busModel,
    this.busType,
    this.driverId,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.isDeleted,
    this.isStartedByDriver,
    this.isEndedByDriver,
    this.startTime,
    this.endTime,
    this.tripTypeId,
    this.lineId,
    this.organizationId,
    this.accessDate,
    this.isActive,
    this.busSupervisorId,
    this.busSupervisorManagerId,
    this.officeID,
    this.isMoved,
    this.moveTime,
    this.confirmFromDriver,
    this.applyNoofDays,
    this.plateNo,
    this.tripType,
    this.lineName,
    this.maxStationOrder,
    this.maxCityOrder,
    this.from,
    this.to,
    this.day,
    this.serviceTypeID,
    this.serviceType,
    this.emptySeat,
    this.price,
    this.tripNumber,
    this.priceAfterDiscount,
    this.isArabic,
  });

  TripListBack.fromJson(dynamic json) {
    tripId = json['TripId'];
    accessBusTime = json['AccessBusTime'];
    busId = json['BusId'];
    busModel = json['BusModel'];
    busType = json['BusType'];
    driverId = json['DriverId'];
    createdBy = json['CreatedBy'];
    creationDate = json['CreationDate'];
    updatedBy = json['UpdatedBy'];
    updateDate = json['UpdateDate'];
    isDeleted = json['IsDeleted'];
    isStartedByDriver = json['IsStartedByDriver'];
    isEndedByDriver = json['IsEndedByDriver'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    tripTypeId = json['TripTypeId'];
    lineId = json['LineId'];
    organizationId = json['OrganizationId'];
    accessDate = json['AccessDate'];
    isActive = json['IsActive'];
    busSupervisorId = json['BusSupervisorId'];
    busSupervisorManagerId = json['BusSupervisorManagerId'];
    officeID = json['OfficeID'];
    isMoved = json['IsMoved'];
    moveTime = json['MoveTime'];
    confirmFromDriver = json['ConfirmFromDriver'];
    applyNoofDays = json['ApplyNoofDays'];
    plateNo = json['PlateNo'];
    tripType = json['TripType'];
    lineName = json['LineName'];
    maxStationOrder = json['MaxStationOrder'];
    maxCityOrder = json['MaxCityOrder'];
    from = json['From'];
    to = json['To'];
    day = json['Day'];
    serviceTypeID = json['ServiceTypeID'];
    serviceType = json['ServiceType'];
    emptySeat = json['EmptySeat'];
    price = json['Price'];
    tripNumber = json['TripNumber'];
    priceAfterDiscount = json['PriceAfterDiscount'];
    isArabic = json['IsArabic'];
  }
  int? tripId;
  String? accessBusTime;
  int? busId;
  dynamic busModel;
  String? busType;
  dynamic driverId;
  dynamic createdBy;
  dynamic creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  bool? isDeleted;
  bool? isStartedByDriver;
  bool? isEndedByDriver;
  dynamic startTime;
  dynamic endTime;
  int? tripTypeId;
  int? lineId;
  dynamic organizationId;
  String? accessDate;
  bool? isActive;
  dynamic busSupervisorId;
  dynamic busSupervisorManagerId;
  dynamic officeID;
  dynamic isMoved;
  dynamic moveTime;
  dynamic confirmFromDriver;
  int? applyNoofDays;
  String? plateNo;
  String? tripType;
  String? lineName;
  dynamic maxStationOrder;
  dynamic maxCityOrder;
  String? from;
  String? to;
  dynamic day;
  int? serviceTypeID;
  String? serviceType;
  int? emptySeat;
  double? price;
  int? tripNumber;
  double? priceAfterDiscount;
  bool? isArabic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TripId'] = tripId;
    map['AccessBusTime'] = accessBusTime;
    map['BusId'] = busId;
    map['BusModel'] = busModel;
    map['BusType'] = busType;
    map['DriverId'] = driverId;
    map['CreatedBy'] = createdBy;
    map['CreationDate'] = creationDate;
    map['UpdatedBy'] = updatedBy;
    map['UpdateDate'] = updateDate;
    map['IsDeleted'] = isDeleted;
    map['IsStartedByDriver'] = isStartedByDriver;
    map['IsEndedByDriver'] = isEndedByDriver;
    map['StartTime'] = startTime;
    map['EndTime'] = endTime;
    map['TripTypeId'] = tripTypeId;
    map['LineId'] = lineId;
    map['OrganizationId'] = organizationId;
    map['AccessDate'] = accessDate;
    map['IsActive'] = isActive;
    map['BusSupervisorId'] = busSupervisorId;
    map['BusSupervisorManagerId'] = busSupervisorManagerId;
    map['OfficeID'] = officeID;
    map['IsMoved'] = isMoved;
    map['MoveTime'] = moveTime;
    map['ConfirmFromDriver'] = confirmFromDriver;
    map['ApplyNoofDays'] = applyNoofDays;
    map['PlateNo'] = plateNo;
    map['TripType'] = tripType;
    map['LineName'] = lineName;
    map['MaxStationOrder'] = maxStationOrder;
    map['MaxCityOrder'] = maxCityOrder;
    map['From'] = from;
    map['To'] = to;
    map['Day'] = day;
    map['ServiceTypeID'] = serviceTypeID;
    map['ServiceType'] = serviceType;
    map['EmptySeat'] = emptySeat;
    map['Price'] = price;
    map['TripNumber'] = tripNumber;
    map['PriceAfterDiscount'] = priceAfterDiscount;
    map['IsArabic'] = isArabic;
    return map;
  }
}

class TripList {
  TripList({
    this.tripId,
    this.accessBusTime,
    this.busId,
    this.busModel,
    this.busType,
    this.driverId,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.isDeleted,
    this.isStartedByDriver,
    this.isEndedByDriver,
    this.startTime,
    this.endTime,
    this.tripTypeId,
    this.lineId,
    this.organizationId,
    this.accessDate,
    this.isActive,
    this.busSupervisorId,
    this.busSupervisorManagerId,
    this.officeID,
    this.isMoved,
    this.moveTime,
    this.confirmFromDriver,
    this.applyNoofDays,
    this.plateNo,
    this.tripType,
    this.lineName,
    this.maxStationOrder,
    this.maxCityOrder,
    this.from,
    this.to,
    this.day,
    this.serviceTypeID,
    this.serviceType,
    this.emptySeat,
    this.price,
    this.busList,
    this.tripTypeList,
    this.lineList,
    this.serviceList,
    this.tripNumber,
    this.priceAfterDiscount,
    this.isArabic,
  });

  TripList.fromJson(dynamic json) {
    tripId = json['TripId'];
    accessBusTime = json['AccessBusTime'];
    busId = json['BusId'];
    busModel = json['BusModel'];
    busType = json['BusType'];
    driverId = json['DriverId'];
    createdBy = json['CreatedBy'];
    creationDate = json['CreationDate'];
    updatedBy = json['UpdatedBy'];
    updateDate = json['UpdateDate'];
    isDeleted = json['IsDeleted'];
    isStartedByDriver = json['IsStartedByDriver'];
    isEndedByDriver = json['IsEndedByDriver'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    tripTypeId = json['TripTypeId'];
    lineId = json['LineId'];
    organizationId = json['OrganizationId'];
    accessDate = json['AccessDate'];
    isActive = json['IsActive'];
    busSupervisorId = json['BusSupervisorId'];
    busSupervisorManagerId = json['BusSupervisorManagerId'];
    officeID = json['OfficeID'];
    isMoved = json['IsMoved'];
    moveTime = json['MoveTime'];
    confirmFromDriver = json['ConfirmFromDriver'];
    applyNoofDays = json['ApplyNoofDays'];
    plateNo = json['PlateNo'];
    tripType = json['TripType'];
    lineName = json['LineName'];
    maxStationOrder = json['MaxStationOrder'];
    maxCityOrder = json['MaxCityOrder'];
    from = json['From'];
    to = json['To'];
    day = json['Day'];
    serviceTypeID = json['ServiceTypeID'];
    serviceType = json['ServiceType'];
    emptySeat = json['EmptySeat'];
    price = json['Price'];
    tripNumber = json['TripNumber'];
    priceAfterDiscount = json['PriceAfterDiscount'];
    isArabic = json['IsArabic'];
  }
  int? tripId;
  String? accessBusTime;
  int? busId;
  dynamic busModel;
  String? busType;
  dynamic driverId;
  dynamic createdBy;
  dynamic creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  bool? isDeleted;
  bool? isStartedByDriver;
  bool? isEndedByDriver;
  dynamic startTime;
  dynamic endTime;
  int? tripTypeId;
  int? lineId;
  dynamic organizationId;
  String? accessDate;
  bool? isActive;
  dynamic busSupervisorId;
  dynamic busSupervisorManagerId;
  dynamic officeID;
  dynamic isMoved;
  dynamic moveTime;
  dynamic confirmFromDriver;
  int? applyNoofDays;
  String? plateNo;
  String? tripType;
  String? lineName;
  dynamic maxStationOrder;
  dynamic maxCityOrder;
  String? from;
  String? to;
  dynamic day;
  int? serviceTypeID;
  String? serviceType;
  int? emptySeat;
  double? price;
  List<dynamic>? busList;
  List<dynamic>? tripTypeList;
  List<dynamic>? lineList;
  List<dynamic>? serviceList;
  int? tripNumber;
  double? priceAfterDiscount;
  bool? isArabic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TripId'] = tripId;
    map['AccessBusTime'] = accessBusTime;
    map['BusId'] = busId;
    map['BusModel'] = busModel;
    map['BusType'] = busType;
    map['DriverId'] = driverId;
    map['CreatedBy'] = createdBy;
    map['CreationDate'] = creationDate;
    map['UpdatedBy'] = updatedBy;
    map['UpdateDate'] = updateDate;
    map['IsDeleted'] = isDeleted;
    map['IsStartedByDriver'] = isStartedByDriver;
    map['IsEndedByDriver'] = isEndedByDriver;
    map['StartTime'] = startTime;
    map['EndTime'] = endTime;
    map['TripTypeId'] = tripTypeId;
    map['LineId'] = lineId;
    map['OrganizationId'] = organizationId;
    map['AccessDate'] = accessDate;
    map['IsActive'] = isActive;
    map['BusSupervisorId'] = busSupervisorId;
    map['BusSupervisorManagerId'] = busSupervisorManagerId;
    map['OfficeID'] = officeID;
    map['IsMoved'] = isMoved;
    map['MoveTime'] = moveTime;
    map['ConfirmFromDriver'] = confirmFromDriver;
    map['ApplyNoofDays'] = applyNoofDays;
    map['PlateNo'] = plateNo;
    map['TripType'] = tripType;
    map['LineName'] = lineName;
    map['MaxStationOrder'] = maxStationOrder;
    map['MaxCityOrder'] = maxCityOrder;
    map['From'] = from;
    map['To'] = to;
    map['Day'] = day;
    map['ServiceTypeID'] = serviceTypeID;
    map['ServiceType'] = serviceType;
    map['EmptySeat'] = emptySeat;
    map['Price'] = price;
    map['TripNumber'] = tripNumber;
    map['PriceAfterDiscount'] = priceAfterDiscount;
    map['IsArabic'] = isArabic;
    return map;
  }
}
