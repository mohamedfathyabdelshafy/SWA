class AccomidationModel {
  AccomidationModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  final String? status;
  final List<Accomidationdetails>? message;
  final dynamic balance;
  final Object? object;
  final dynamic text;
  final dynamic obj;

  factory AccomidationModel.fromJson(Map<String, dynamic> json) {
    return AccomidationModel(
      status: json["status"],
      message: json["message"] == null
          ? []
          : List<Accomidationdetails>.from(
              json["message"]!.map((x) => Accomidationdetails.fromJson(x))),
      balance: json["balance"],
      object: json["Object"] == null ? null : Object.fromJson(json["Object"]),
      text: json["Text"],
      obj: json["Obj"],
    );
  }
}

class Accomidationdetails {
  Accomidationdetails({
    this.numberNights,
    this.cityName,
    this.cityId,
    this.hotelId,
    this.description,
    this.price,
    this.roomTypeList,
    this.accommodationType,
    this.withMoreLink,
    this.moreLink,
    this.isRequired,
    this.accessDate,
    this.tripUmrahAccommodationId,
    this.isReserved,
    this.tripUmrahId,
    this.isArabic,
  });

  final int? numberNights;
  final String? cityName;
  final int? cityId;
  final int? hotelId;
  final List<String>? description;
  final dynamic price;
  final List<RoomTypeList>? roomTypeList;
  final String? accommodationType;
  final bool? withMoreLink;
  final dynamic moreLink;
  final bool? isRequired;
  final String? accessDate;
  final int? tripUmrahAccommodationId;
  final bool? isReserved;
  final int? tripUmrahId;
  final bool? isArabic;

  factory Accomidationdetails.fromJson(Map<String, dynamic> json) {
    return Accomidationdetails(
      numberNights: json["NumberNights"],
      cityName: json["CityName"],
      cityId: json["CityID"],
      hotelId: json["HotelID"],
      description: json["Description"] == null
          ? []
          : List<String>.from(json["Description"]!.map((x) => x)),
      price: json["Price"],
      roomTypeList: json["RoomTypeList"] == null
          ? []
          : List<RoomTypeList>.from(
              json["RoomTypeList"]!.map((x) => RoomTypeList.fromJson(x))),
      accommodationType: json["AccommodationType"],
      withMoreLink: json["WithMoreLink"],
      moreLink: json["MoreLink"],
      isRequired: json["IsRequired"],
      accessDate: json["AccessDate"],
      tripUmrahAccommodationId: json["TripUmrahAccommodationID"],
      isReserved: json["IsReserved"],
      tripUmrahId: json["TripUmrahID"],
      isArabic: json["IsArabic"],
    );
  }
}

class RoomTypeList {
  RoomTypeList({
    this.numberAllow,
    this.accomodationRoomTypeId,
    this.accomdationId,
    this.typeRoom,
    this.price,
    this.isDeleted,
    this.isActive,
    this.moreLink,
    this.withMoreLink,
    this.description,
    this.priceBeforeDiscount,
    this.discount,
    this.image,
    this.isreserved,
    this.personCountReserved,
    this.isArabic,
  });

  final int? numberAllow;
  final int? accomodationRoomTypeId;
  final int? accomdationId;
  final String? typeRoom;
  final dynamic price;
  final bool? isDeleted;
  final bool? isActive;
  final dynamic moreLink;
  final dynamic withMoreLink;
  final String? description;
  final dynamic priceBeforeDiscount;
  final dynamic discount;
  final String? image;
  final bool? isreserved;
  final int? personCountReserved;
  final bool? isArabic;

  factory RoomTypeList.fromJson(Map<String, dynamic> json) {
    return RoomTypeList(
      numberAllow: json["NumberAllow"],
      accomodationRoomTypeId: json["AccomodationRoomTypeID"],
      accomdationId: json["AccomdationID"],
      typeRoom: json["TypeRoom"],
      price: json["Price"],
      isDeleted: json["IsDeleted"],
      isActive: json["IsActive"],
      moreLink: json["MoreLink"],
      withMoreLink: json["WithMoreLink"],
      description: json["Description"],
      priceBeforeDiscount: json["PriceBeforeDiscount"],
      discount: json["Discount"],
      image: json["Image"],
      isreserved: json["Isreserved"],
      personCountReserved: json["PersonCountReserved"],
      isArabic: json["IsArabic"],
    );
  }
}

class Object {
  Object({
    this.isLinkWithTransportation,
  });

  final bool? isLinkWithTransportation;

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
      isLinkWithTransportation: json["IsLinkWithTransportation"],
    );
  }
}
