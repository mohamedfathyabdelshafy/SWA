class TimesTripsResponse {
  TimesTripsResponse({
    this.data,
    this.status,
    this.message,
    this.failureMessage,
    this.balance,
    this.object,
    this.text,
    this.isAuthorized,
    this.obj,
  });

  dynamic data;
  String? status;
  Message? message;

  String? failureMessage;
  dynamic balance;
  dynamic object;
  dynamic text;
  bool? isAuthorized;
  dynamic obj;

  TimesTripsResponse.fromJson(Map<String, dynamic> json) {
    data = json["data"];
    status = json["status"];

    if (status == "success") {
      message =
          json["message"] == null ? null : Message.fromJson(json["message"]);
    } else {
      failureMessage = json["message"];
    }
    balance = json["balance"];
    object = json["Object"];
    text = json["Text"];
    isAuthorized = json["isAuthorized"];
    obj = json["Obj"];
  }
}

class Message {
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

  List<TripList> tripList;
  List<TripList> tripListBack;
  dynamic fromStationIdGo;
  dynamic toStationIdGo;
  dynamic tripDateGo;
  dynamic fromStationIdBack;
  dynamic toStationIdBack;
  dynamic tripDateBack;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      tripList: json["TripList"] == null
          ? []
          : List<TripList>.from(
              json["TripList"]!.map((x) => TripList.fromJson(x))),
      tripListBack: json["TripListBack"] == null
          ? []
          : List<TripList>.from(
              json["TripListBack"]!.map((x) => TripList.fromJson(x))),
      fromStationIdGo: json["FromStationIDGo"],
      toStationIdGo: json["ToStationIDGo"],
      tripDateGo: json["TripDateGo"],
      fromStationIdBack: json["FromStationIDBack"],
      toStationIdBack: json["ToStationIDBack"],
      tripDateBack: json["TripDateBack"],
    );
  }
}

class TripList {
  TripList({
    required this.fromStationId,
    required this.toStationId,
    required this.fromCityId,
    required this.toCityId,
    required this.arrivalDate,
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
    required this.userLoginId,
    required this.accessTripTime,
    required this.startTime,
    required this.endTime,
    required this.tripTypeId,
    required this.lineId,
    required this.organizationId,
    required this.partnerId,
    required this.type,
    required this.accessDate,
    required this.isActive,
    required this.busSupervisorId,
    required this.busSupervisorManagerId,
    required this.officeId,
    required this.settingList,
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
    required this.countryId,
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
    required this.currencyName,
    required this.currencySymbole,
    required this.discount,
    required this.isArabic,
    this.companyName,
    this.logo,
  });

  dynamic fromStationId;
  dynamic toStationId;
  dynamic fromCityId;
  dynamic toCityId;
  DateTime? arrivalDate;
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
  dynamic userLoginId;
  dynamic accessTripTime;
  dynamic startTime;
  dynamic endTime;
  int? tripTypeId;
  int? lineId;
  dynamic organizationId;
  dynamic partnerId;
  int? type;
  DateTime? accessDate;
  bool? isActive;
  dynamic busSupervisorId;
  dynamic busSupervisorManagerId;
  dynamic officeId;
  List<dynamic> settingList;
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
  dynamic toCityName;
  dynamic fromCityName;
  dynamic day;
  int? serviceTypeId;
  String? serviceType;
  int? emptySeat;
  int? countryId;
  dynamic price;
  List<dynamic> busList;
  List<dynamic> tripTypeList;
  List<dynamic> lineList;
  List<dynamic> serviceList;
  int? tripNumber;
  dynamic priceAfterDiscount;
  dynamic pickupTime;
  dynamic arrivalTime;
  List<LineCity> lineCity;
  String? timeOfCustomerStation;
  dynamic currencyName;
  dynamic currencySymbole;
  dynamic discount;
  String? companyName;
  String? logo;
  bool? isArabic;

  factory TripList.fromJson(Map<String, dynamic> json) {
    return TripList(
      fromStationId: json["FromStationID"],
      toStationId: json["ToStationID"],
      fromCityId: json["FromCityID"],
      toCityId: json["ToCityID"],
      arrivalDate: DateTime.tryParse(json["ArrivalDate"] ?? ""),
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
      userLoginId: json["UserLoginID"],
      accessTripTime: json["AccessTripTime"],
      startTime: json["StartTime"],
      endTime: json["EndTime"],
      tripTypeId: json["TripTypeId"],
      lineId: json["LineId"],
      organizationId: json["OrganizationId"],
      partnerId: json["PartnerId"],
      type: json["Type"],
      accessDate: DateTime.tryParse(json["AccessDate"] ?? ""),
      isActive: json["IsActive"],
      busSupervisorId: json["BusSupervisorId"],
      busSupervisorManagerId: json["BusSupervisorManagerId"],
      officeId: json["OfficeID"],
      settingList: json["SettingList"] == null
          ? []
          : List<dynamic>.from(json["SettingList"]!.map((x) => x)),
      isMoved: json["IsMoved"],
      moveTime: json["MoveTime"],
      confirmFromDriver: json["ConfirmFromDriver"],
      applyNoofDays: json["ApplyNoofDays"],
      plateNo: json["PlateNo"],
      tripType: json["TripType"],
      lineName: json["LineName"],
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
      countryId: json["CountryID"],
      price: json["Price"],
      busList: json["BusList"] == null
          ? []
          : List<dynamic>.from(json["BusList"]!.map((x) => x)),
      tripTypeList: json["TripTypeList"] == null
          ? []
          : List<dynamic>.from(json["TripTypeList"]!.map((x) => x)),
      lineList: json["LineList"] == null
          ? []
          : List<dynamic>.from(json["LineList"]!.map((x) => x)),
      serviceList: json["ServiceList"] == null
          ? []
          : List<dynamic>.from(json["ServiceList"]!.map((x) => x)),
      tripNumber: json["TripNumber"],
      priceAfterDiscount: json["PriceAfterDiscount"],
      pickupTime: json["PickupTime"],
      arrivalTime: json["ArrivalTime"],
      lineCity: json["LineCity"] == null
          ? []
          : List<LineCity>.from(
              json["LineCity"]!.map((x) => LineCity.fromJson(x))),
      timeOfCustomerStation: json["TimeOfCustomerStation"],
      currencyName: json["CurrencyName"],
      currencySymbole: json["CurrencySymbole"],
      discount: json["Discount"],
      isArabic: json["IsArabic"],
      companyName: json["CompanyName"],
      logo: json["Logo"],
    );
  }
}

class LineCity {
  LineCity({
    required this.lineCityId,
    required this.cityId,
    required this.countryId,
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
    required this.partnerId,
    required this.lineName,
    required this.stationIdList,
    required this.stationList,
    required this.cityName,
    required this.userLogInId,
    required this.lineType,
    required this.governorateName,
    required this.isArabic,
  });

  int? lineCityId;
  int? cityId;
  int? countryId;
  int? orderIndex;
  dynamic createdBy;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  bool? isDelete;
  bool? isActive;
  List<LineStationList> lineStationList;
  int? governorateId;
  int? lineId;
  dynamic partnerId;
  String? lineName;
  dynamic stationIdList;
  List<dynamic> stationList;
  String? cityName;
  dynamic userLogInId;
  dynamic lineType;
  String? governorateName;
  bool? isArabic;

  factory LineCity.fromJson(Map<String, dynamic> json) {
    return LineCity(
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
          : List<LineStationList>.from(
              json["LineStationList"]!.map((x) => LineStationList.fromJson(x))),
      governorateId: json["GovernorateID"],
      lineId: json["LineID"],
      partnerId: json["PartnerID"],
      lineName: json["LineName"],
      stationIdList: json["StationIDList"],
      stationList: json["StationList"] == null
          ? []
          : List<dynamic>.from(json["StationList"]!.map((x) => x)),
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
    required this.lineCityStationId,
    required this.lineCityId,
    required this.stationId,
    required this.stationName,
    required this.orderIndex,
    required this.isActive,
    required this.isDelete,
    required this.lineId,
    required this.lineName,
    required this.userLogInId,
    required this.cityId,
    required this.cityName,
    required this.afterMinuts,
    required this.station,
    required this.accessPoinName,
    required this.createdBy,
    required this.creationDate,
    required this.updatedBy,
    required this.updateDate,
    required this.userLoginId,
    required this.governorateId,
    required this.partnerId,
    required this.afterMins,
    required this.countryId,
    required this.accessTime,
    required this.isArabic,
    this.companyName,
    this.logo,
  });

  int? lineCityStationId;
  int? lineCityId;
  int? stationId;
  String? stationName;
  int? orderIndex;
  bool? isActive;
  bool? isDelete;
  int? lineId;
  String? lineName;
  dynamic userLogInId;
  dynamic cityId;
  String? cityName;
  int? afterMinuts;
  Station? station;
  dynamic accessPoinName;
  dynamic createdBy;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  dynamic userLoginId;
  dynamic governorateId;
  dynamic partnerId;
  int? afterMins;
  int? countryId;
  String? accessTime;
  String? companyName;
  String? logo;
  bool? isArabic;

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
      station:
          json["Station"] == null ? null : Station.fromJson(json["Station"]),
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
      companyName: json["CompanyName"],
      logo: json["Logo"],
    );
  }
}

class Station {
  Station({
    required this.stationId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.countryId,
    required this.governorateId,
    required this.universityId,
    required this.cityId,
    required this.isActive,
    required this.governorateName,
    required this.cityName,
    required this.city,
    required this.governorate,
    required this.country,
    required this.cityList,
    required this.countryList,
    required this.governorateList,
    required this.universityList,
    required this.isDeleted,
    required this.createdBy,
    required this.creationDate,
    required this.updatedBy,
    required this.userLoginId,
    required this.updateDate,
    required this.nameAr,
    required this.nameEn,
    required this.stationTypeList,
    required this.stationTypeId,
    required this.stationType,
  });

  int? stationId;
  String? name;
  String? latitude;
  String? longitude;
  dynamic description;
  int? countryId;
  int? governorateId;
  dynamic universityId;
  int? cityId;
  bool? isActive;
  String? governorateName;
  String? cityName;
  dynamic city;
  dynamic governorate;
  dynamic country;
  List<dynamic> cityList;
  List<dynamic> countryList;
  List<dynamic> governorateList;
  List<dynamic> universityList;
  bool? isDeleted;
  String? createdBy;
  DateTime? creationDate;
  String? updatedBy;
  dynamic userLoginId;
  DateTime? updateDate;
  String? nameAr;
  String? nameEn;
  List<dynamic> stationTypeList;
  int? stationTypeId;
  dynamic stationType;

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
      cityList: json["CityList"] == null
          ? []
          : List<dynamic>.from(json["CityList"]!.map((x) => x)),
      countryList: json["CountryList"] == null
          ? []
          : List<dynamic>.from(json["CountryList"]!.map((x) => x)),
      governorateList: json["GovernorateList"] == null
          ? []
          : List<dynamic>.from(json["GovernorateList"]!.map((x) => x)),
      universityList: json["UniversityList"] == null
          ? []
          : List<dynamic>.from(json["UniversityList"]!.map((x) => x)),
      isDeleted: json["IsDeleted"],
      createdBy: json["CreatedBy"],
      creationDate: DateTime.tryParse(json["CreationDate"] ?? ""),
      updatedBy: json["UpdatedBy"],
      userLoginId: json["UserLoginID"],
      updateDate: DateTime.tryParse(json["UpdateDate"] ?? ""),
      nameAr: json["NameAr"],
      nameEn: json["NameEn"],
      stationTypeList: json["StationTypeList"] == null
          ? []
          : List<dynamic>.from(json["StationTypeList"]!.map((x) => x)),
      stationTypeId: json["StationTypeID"],
      stationType: json["StationType"],
    );
  }
}
