// To parse this JSON data, do
//
//     final triplistmodel = triplistmodelFromJson(jsonString);

import 'dart:convert';

Triplistmodel triplistmodelFromJson(String str) =>
    Triplistmodel.fromJson(json.decode(str));

class Triplistmodel {
  String? status;
  List<Campainlist>? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  Triplistmodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory Triplistmodel.fromJson(Map<String, dynamic> json) => Triplistmodel(
        status: json["status"],
        message: List<Campainlist>.from(
            json["message"].map((x) => Campainlist.fromJson(x))),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );
}

class Campainlist {
  int? campiagnUmraId;
  String? name;
  bool? isActive;
  bool? isDelete;
  dynamic createdBy;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  List<TripList>? tripList;
  List<DetailsList>? detailsList;
  String? image;
  String? bgColor;

  Campainlist({
    this.campiagnUmraId,
    this.name,
    this.isActive,
    this.isDelete,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.tripList,
    this.detailsList,
    this.image,
    this.bgColor,
  });

  factory Campainlist.fromJson(Map<String, dynamic> json) => Campainlist(
        campiagnUmraId: json["CampiagnUmraID"],
        name: json["Name"],
        isActive: json["IsActive"],
        isDelete: json["IsDelete"],
        createdBy: json["CreatedBy"],
        creationDate: DateTime.parse(json["CreationDate"]),
        updatedBy: json["UpdatedBy"],
        updateDate: json["UpdateDate"],
        tripList: json["TripList"] == null
            ? []
            : List<TripList>.from(
                json["TripList"].map((x) => TripList.fromJson(x))),
        detailsList: List<DetailsList>.from(
            json["DetailsList"].map((x) => DetailsList.fromJson(x))),
        image: json["Image"],
        bgColor: json["BgColor"],
      );
}

class DetailsList {
  int? capaignUmraDetailsId;
  int? campaignId;
  String? description;
  bool? isDelete;
  bool? isActive;
  dynamic createdBy;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updateDate;

  DetailsList({
    this.capaignUmraDetailsId,
    this.campaignId,
    this.description,
    this.isDelete,
    this.isActive,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
  });

  factory DetailsList.fromJson(Map<String, dynamic> json) => DetailsList(
        capaignUmraDetailsId: json["CapaignUmraDetailsID"],
        campaignId: json["CampaignID"],
        description: json["Description"],
        isDelete: json["IsDelete"],
        isActive: json["IsActive"],
        createdBy: json["CreatedBy"],
        creationDate: DateTime.parse(json["CreationDate"]),
        updatedBy: json["UpdatedBy"],
        updateDate: json["UpdateDate"],
      );
}

class TripList {
  int? tripUmraId;
  int? tripGoId;
  DateTime? tripDateGo;
  DateTime? tripDateBack;
  int? tripIdBack;
  int? tripTypeUmrahId;
  String? tripTypeName;
  int? nights;
  int? campaignId;
  String? campaignName;
  dynamic price;
  bool? withTransportaion;
  dynamic hotelId;
  String? hotelName;
  int? stars;
  dynamic notes;
  bool? isDelete;
  bool? isActive;
  dynamic createdBy;
  int? availability;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  String? tripTime;
  String? tripTimeGo;
  String? tripTimeBack;
  String? toGo;
  String? fromGo;
  String? toBack;
  String? fromBack;
  int? lineIdGo;
  int? lineIdBack;
  int? busIdGo;
  int? busIdBack;
  String? fromStationNameGo;
  int? fromStationIdGo;
  String? toStationNameGo;
  int? toStationIdGo;
  String? fromStationNameBack;
  int? fromStationIdBack;
  String? toStationNameBack;
  int? toStationIdBack;
  int? serviceTypeIdGo;
  int? serviceTypeIdBack;
  List<NightsList>? nightsList;

  TripList(
      {this.tripUmraId,
      this.tripGoId,
      this.tripDateGo,
      this.tripDateBack,
      this.tripIdBack,
      this.tripTypeUmrahId,
      this.tripTypeName,
      this.nights,
      this.campaignId,
      this.campaignName,
      this.price,
      this.withTransportaion,
      this.hotelId,
      this.hotelName,
      this.stars,
      this.notes,
      this.isDelete,
      this.isActive,
      this.createdBy,
      this.availability,
      this.creationDate,
      this.updatedBy,
      this.updateDate,
      this.tripTime,
      this.tripTimeGo,
      this.tripTimeBack,
      this.toGo,
      this.fromGo,
      this.toBack,
      this.fromBack,
      this.lineIdGo,
      this.lineIdBack,
      this.busIdGo,
      this.busIdBack,
      this.fromStationNameGo,
      this.fromStationIdGo,
      this.toStationNameGo,
      this.toStationIdGo,
      this.fromStationNameBack,
      this.fromStationIdBack,
      this.toStationNameBack,
      this.toStationIdBack,
      this.serviceTypeIdGo,
      this.serviceTypeIdBack,
      this.nightsList});

  factory TripList.fromJson(Map<String, dynamic> json) => TripList(
        tripUmraId: json["TripUmraID"],
        tripGoId: json["TripGoID"],
        tripDateGo: DateTime.parse(json["TripDateGo"]),
        tripDateBack: DateTime.parse(json["TripDateBack"]),
        tripIdBack: json["TripIDBack"],
        tripTypeUmrahId: json["TripTypeUmrahID"],
        tripTypeName: json["TripTypeName"],
        nights: json["Nights"],
        campaignId: json["CampaignID"],
        campaignName: json["CampaignName"],
        price: json["Price"],
        withTransportaion: json["WithTransportaion"],
        hotelId: json["HotelID"],
        hotelName: json["HotelName"],
        stars: json["Stars"],
        notes: json["Notes"],
        isDelete: json["IsDelete"],
        isActive: json["IsActive"],
        createdBy: json["CreatedBy"],
        availability: json["Availability"],
        creationDate: DateTime.parse(json["CreationDate"]),
        updatedBy: json["UpdatedBy"],
        updateDate: json["UpdateDate"],
        tripTime: json["TripTime"],
        tripTimeGo: json["TripTimeGo"],
        tripTimeBack: json["TripTimeBack"],
        toGo: json["ToGo"],
        fromGo: json["FromGo"],
        toBack: json["ToBack"],
        fromBack: json["FromBack"],
        lineIdGo: json["LineIDGo"],
        lineIdBack: json["LineIDBack"],
        busIdGo: json["BusIDGo"],
        busIdBack: json["BusIDBack"],
        fromStationNameGo: json["FromStationNameGo"],
        fromStationIdGo: json["FromStationIDGo"],
        toStationNameGo: json["ToStationNameGo"],
        toStationIdGo: json["ToStationIDGo"],
        fromStationNameBack: json["FromStationNameBack"],
        fromStationIdBack: json["FromStationIDBack"],
        toStationNameBack: json["ToStationNameBack"],
        toStationIdBack: json["ToStationIDBack"],
        serviceTypeIdGo: json["ServiceTypeIDGo"],
        serviceTypeIdBack: json["ServiceTypeIDBack"],
        nightsList: List<NightsList>.from(
            json["NightsList"].map((x) => NightsList.fromJson(x))),
      );
}

class NightsList {
  int? numberNights;
  String? cityName;

  NightsList({
    this.numberNights,
    this.cityName,
  });

  factory NightsList.fromJson(Map<String, dynamic> json) => NightsList(
        numberNights: json["NumberNights"],
        cityName: json["CityName"],
      );

  Map<String, dynamic> toJson() => {
        "NumberNights": numberNights,
        "CityName": cityName,
      };
}
