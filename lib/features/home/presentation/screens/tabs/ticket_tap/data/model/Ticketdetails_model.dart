class TicketdetailsModel {
  TicketdetailsModel({
    this.data,
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.isAuthorized,
    this.obj,
  });

  final dynamic data;
  final String? status;
  final Message? message;
  final dynamic balance;
  final dynamic object;
  final dynamic text;
  final bool? isAuthorized;
  final dynamic obj;

  factory TicketdetailsModel.fromJson(Map<String, dynamic> json) {
    return TicketdetailsModel(
      data: json["data"],
      status: json["status"],
      message: json["message"] == null ? null : Message.fromJson(json["message"]),
      balance: json["balance"],
      object: json["Object"],
      text: json["Text"],
      isAuthorized: json["isAuthorized"],
      obj: json["Obj"],
    );
  }
}

class Message {
  Message({
    this.cities,
    this.reservationId,
    this.customerName,
    this.customerPhone,
    this.description,
    this.tripId,
    this.busId,
    this.status,
    this.statusName,
    this.createdBy,
    this.creationDate,
    this.partnerName,
    this.organizationName,
    this.logoFilePath,
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
    this.arrivalTime,
    this.qrCode,
    this.seatNumbers,
    this.policy,
    this.arrivaltime,
  });

  final List<City>? cities;
  final int? reservationId;
  final String? customerName;
  final String? customerPhone;
  final dynamic description;
  final int? tripId;
  final int? busId;
  final int? status;
  final String? statusName;
  final String? createdBy;
  final String? creationDate;
  final dynamic partnerName;
  final dynamic organizationName;
  final dynamic logoFilePath;
  final dynamic organizationId;
  final dynamic price;
  final dynamic penalty;
  final dynamic returnPrice;
  final int? seatNo;
  final String? plateNo;
  final String? accessBusTime;
  final String? lineName;
  final int? maxCityOrder;
  final String? from;
  final String? to;
  final int? fromStationId;
  final int? toStationId;
  final String? tripDate;
  final String? tripType;
  final bool? cancelled;
  final String? serviceType;
  final String? tripNumber;
  final String? ticketNumber;
  final String? arrivalTime;
  final dynamic qrCode;
  final String? seatNumbers;
  final List<String>? policy;

  String? arrivaltime;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      cities: json["Cities"] == null ? [] : List<City>.from(json["Cities"]!.map((x) => City.fromJson(x))),
      reservationId: json["ReservationID"],
      customerName: json["CustomerName"],
      customerPhone: json["CustomerPhone"],
      description: json["Description"],
      tripId: json["TripID"],
      busId: json["BusID"],
      status: json["Status"],
      statusName: json["StatusName"],
      createdBy: json["CreatedBy"],
      creationDate: json["CreationDate"],
      partnerName: json["PartnerName"],
      organizationName: json["OrganizationName"],
      logoFilePath: json["LogoFilePath"],
      organizationId: json["OrganizationID"],
      price: json["Price"],
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
      arrivalTime: json["ArrivalTime"],
      qrCode: json["QrCode"],
      seatNumbers: json["SeatNumbers"],
      arrivaltime: json["ArrivalTime"],
      policy: json["Policy"] == null ? [] : List<String>.from(json["Policy"]!.map((x) => x)),
    );
  }
}

class City {
  City({
    this.lineCityId,
    this.cityId,
    this.countryId,
    this.orderIndex,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.isDelete,
    this.isActive,
    this.lineStationList,
    this.governorateId,
    this.lineId,
    this.partnerId,
    this.lineName,
    this.stationIdList,
    this.stationList,
    this.cityName,
    this.userLogInId,
    this.lineType,
    this.governorateName,
    this.isArabic,
  });

  final int? lineCityId;
  final int? cityId;
  final int? countryId;
  final int? orderIndex;
  final dynamic createdBy;
  final DateTime? creationDate;
  final dynamic updatedBy;
  final dynamic updateDate;
  final bool? isDelete;
  final bool? isActive;
  final List<LineStationList>? lineStationList;
  final int? governorateId;
  final int? lineId;
  final dynamic partnerId;
  final String? lineName;
  final dynamic stationIdList;
  final List<dynamic>? stationList;
  final String? cityName;
  final dynamic userLogInId;
  final dynamic lineType;
  final String? governorateName;
  final bool? isArabic;

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      lineCityId: json["LineCityID"],
      cityId: json["CityID"],
      countryId: json["CountryID"],
      orderIndex: json["OrderIndex"],
      createdBy: json["CreatedBy"],
      creationDate: DateTime.tryParse(json["CreationDate"] ?? ""),
      updatedBy: json["UpdatedBy"],
      updateDate: json["UpdateDate"],
      isDelete: json["IsDelete"],
      isActive: json["IsActive"],
      lineStationList: json["LineStationList"] == null
          ? []
          : List<LineStationList>.from(json["LineStationList"]!.map((x) => LineStationList.fromJson(x))),
      governorateId: json["GovernorateID"],
      lineId: json["LineID"],
      partnerId: json["PartnerID"],
      lineName: json["LineName"],
      stationIdList: json["StationIDList"],
      stationList: json["StationList"] == null ? [] : List<dynamic>.from(json["StationList"]!.map((x) => x)),
      cityName: json["CityName"],
      userLogInId: json["UserLogInID"],
      lineType: json["LineType"],
      governorateName: json["GovernorateName"],
      isArabic: json["IsArabic"],
    );
  }
}

class LineStationList {
  LineStationList({
    this.lineCityStationId,
    this.lineCityId,
    this.stationId,
    this.stationName,
    this.orderIndex,
    this.isActive,
    this.isDelete,
    this.lineId,
    this.lineName,
    this.userLogInId,
    this.cityId,
    this.cityName,
    this.afterMinuts,
    this.station,
    this.accessPoinName,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.userLoginId,
    this.governorateId,
    this.partnerId,
    this.afterMins,
    this.countryId,
    this.accessTime,
    this.isArabic,
  });

  final int? lineCityStationId;
  final int? lineCityId;
  final int? stationId;
  final String? stationName;
  final int? orderIndex;
  final bool? isActive;
  final bool? isDelete;
  final int? lineId;
  final String? lineName;
  final dynamic userLogInId;
  final int? cityId;
  final String? cityName;
  final int? afterMinuts;
  final Station? station;
  final dynamic accessPoinName;
  final dynamic createdBy;
  final DateTime? creationDate;
  final dynamic updatedBy;
  final dynamic updateDate;
  final dynamic userLoginId;
  final dynamic governorateId;
  final dynamic partnerId;
  final int? afterMins;
  final int? countryId;
  final String? accessTime;
  final bool? isArabic;

  factory LineStationList.fromJson(Map<String, dynamic> json) {
    return LineStationList(
      lineCityStationId: json["LineCityStationID"],
      lineCityId: json["LineCityID"],
      stationId: json["StationID"],
      stationName: json["StationName"],
      orderIndex: json["OrderIndex"],
      isActive: json["IsActive"],
      isDelete: json["IsDelete"],
      lineId: json["LineID"],
      lineName: json["LineName"],
      userLogInId: json["UserLogInID"],
      cityId: json["CityID"],
      cityName: json["CityName"],
      afterMinuts: json["AfterMinuts"],
      station: json["Station"] == null ? null : Station.fromJson(json["Station"]),
      accessPoinName: json["AccessPoinName"],
      createdBy: json["CreatedBy"],
      creationDate: DateTime.tryParse(json["CreationDate"] ?? ""),
      updatedBy: json["UpdatedBy"],
      updateDate: json["UpdateDate"],
      userLoginId: json["UserLoginID"],
      governorateId: json["GovernorateID"],
      partnerId: json["PartnerID"],
      afterMins: json["AfterMins"],
      countryId: json["CountryID"],
      accessTime: json["AccessTime"],
      isArabic: json["IsArabic"],
    );
  }
}

class Station {
  Station({
    this.stationId,
    this.name,
    this.latitude,
    this.longitude,
    this.description,
    this.countryId,
    this.governorateId,
    this.universityId,
    this.cityId,
    this.isActive,
    this.governorateName,
    this.cityName,
    this.city,
    this.governorate,
    this.country,
    this.cityList,
    this.countryList,
    this.governorateList,
    this.universityList,
    this.isDeleted,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.userLoginId,
    this.updateDate,
    this.nameAr,
    this.nameEn,
    this.stationTypeList,
    this.stationTypeId,
    this.stationType,
  });

  final int? stationId;
  final String? name;
  final String? latitude;
  final String? longitude;
  final dynamic description;
  final int? countryId;
  final int? governorateId;
  final dynamic universityId;
  final int? cityId;
  final bool? isActive;
  final String? governorateName;
  final String? cityName;
  final dynamic city;
  final dynamic governorate;
  final dynamic country;
  final List<dynamic>? cityList;
  final List<dynamic>? countryList;
  final List<dynamic>? governorateList;
  final List<dynamic>? universityList;
  final bool? isDeleted;
  final String? createdBy;
  final DateTime? creationDate;
  final String? updatedBy;
  final dynamic userLoginId;
  final DateTime? updateDate;
  final String? nameAr;
  final String? nameEn;
  final List<dynamic>? stationTypeList;
  final int? stationTypeId;
  final dynamic stationType;

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationId: json["StationId"],
      name: json["Name"],
      latitude: json["Latitude"],
      longitude: json["Longitude"],
      description: json["Description"],
      countryId: json["CountryID"],
      governorateId: json["GovernorateID"],
      universityId: json["UniversityID"],
      cityId: json["CityId"],
      isActive: json["IsActive"],
      governorateName: json["GovernorateName"],
      cityName: json["CityName"],
      city: json["City"],
      governorate: json["Governorate"],
      country: json["Country"],
      cityList: json["CityList"] == null ? [] : List<dynamic>.from(json["CityList"]!.map((x) => x)),
      countryList: json["CountryList"] == null ? [] : List<dynamic>.from(json["CountryList"]!.map((x) => x)),
      governorateList:
          json["GovernorateList"] == null ? [] : List<dynamic>.from(json["GovernorateList"]!.map((x) => x)),
      universityList: json["UniversityList"] == null ? [] : List<dynamic>.from(json["UniversityList"]!.map((x) => x)),
      isDeleted: json["IsDeleted"],
      createdBy: json["CreatedBy"],
      creationDate: DateTime.tryParse(json["CreationDate"] ?? ""),
      updatedBy: json["UpdatedBy"],
      userLoginId: json["UserLoginID"],
      updateDate: DateTime.tryParse(json["UpdateDate"] ?? ""),
      nameAr: json["NameAr"],
      nameEn: json["NameEn"],
      stationTypeList:
          json["StationTypeList"] == null ? [] : List<dynamic>.from(json["StationTypeList"]!.map((x) => x)),
      stationTypeId: json["StationTypeID"],
      stationType: json["StationType"],
    );
  }
}
