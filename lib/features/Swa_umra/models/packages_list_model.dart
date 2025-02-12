// To parse this JSON data, do
//
//     final packagesModel = packagesModelFromJson(jsonString);

import 'dart:convert';

PackagesModel packagesModelFromJson(String str) =>
    PackagesModel.fromJson(json.decode(str));

class PackagesModel {
  String? status;
  List<Message>? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  PackagesModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory PackagesModel.fromJson(Map<String, dynamic> json) => PackagesModel(
        status: json["status"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );
}

class Message {
  int? campiagnUmraId;
  String? name;
  bool? isActive;
  bool? isDelete;
  dynamic createdBy;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  List<NightList>? nightList;
  List<DetailsList>? detailsList;
  String? image;
  String? bgColor;
  String? tripDate;
  String? tripTime;
  int? availability;
  bool? withTransportation;
  bool? isRequired;
  String? accommodationType;
  bool? isReserved;
  int? tripUmrahId;

  Message({
    this.campiagnUmraId,
    this.name,
    this.isActive,
    this.isDelete,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.nightList,
    this.detailsList,
    this.image,
    this.bgColor,
    this.tripDate,
    this.tripTime,
    this.availability,
    this.withTransportation,
    this.isRequired,
    this.accommodationType,
    this.isReserved,
    this.tripUmrahId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        campiagnUmraId: json["CampiagnUmraID"],
        name: json["Name"],
        isActive: json["IsActive"],
        isDelete: json["IsDelete"],
        createdBy: json["CreatedBy"],
        creationDate: DateTime.parse(json["CreationDate"]),
        updatedBy: json["UpdatedBy"],
        updateDate: json["UpdateDate"],
        nightList: List<NightList>.from(
            json["NightList"].map((x) => NightList.fromJson(x))),
        detailsList: List<DetailsList>.from(
            json["DetailsList"].map((x) => DetailsList.fromJson(x))),
        image: json["Image"],
        bgColor: json["BgColor"],
        tripDate: json["TripDate"],
        tripTime: json["TripTime"],
        availability: json["Availability"],
        withTransportation: json["WithTransportation"],
        isRequired: json["IsRequired"],
        accommodationType: json["AccommodationType"],
        isReserved: json["IsReserved"],
        tripUmrahId: json["TripUmrahID"],
      );
}

class DetailsList {
  int? tripUmrahDetailsId;
  int? tripUmrahId;
  bool? isTtitle;
  String? description;
  dynamic moreLink;
  bool? withMoreLink;
  dynamic image;
  bool? isDelete;
  bool? isActive;
  dynamic titleId;

  DetailsList({
    this.tripUmrahDetailsId,
    this.tripUmrahId,
    this.isTtitle,
    this.description,
    this.moreLink,
    this.withMoreLink,
    this.image,
    this.isDelete,
    this.isActive,
    this.titleId,
  });

  factory DetailsList.fromJson(Map<String, dynamic> json) => DetailsList(
        tripUmrahDetailsId: json["TripUmrahDetailsID"],
        tripUmrahId: json["TripUmrahID"],
        isTtitle: json["IsTtitle"],
        description: json["Description"],
        moreLink: json["MoreLink"],
        withMoreLink: json["WithMoreLink"],
        image: json["Image"],
        isDelete: json["IsDelete"],
        isActive: json["IsActive"],
        titleId: json["TitleID"],
      );

  Map<String, dynamic> toJson() => {
        "TripUmrahDetailsID": tripUmrahDetailsId,
        "TripUmrahID": tripUmrahId,
        "IsTtitle": isTtitle,
        "Description": description,
        "MoreLink": moreLink,
        "WithMoreLink": withMoreLink,
        "Image": image,
        "IsDelete": isDelete,
        "IsActive": isActive,
        "TitleID": titleId,
      };
}

class NightList {
  int? nights;
  String? cityName;

  NightList({
    this.nights,
    this.cityName,
  });

  factory NightList.fromJson(Map<String, dynamic> json) => NightList(
        nights: json["Nights"],
        cityName: json["CityName"],
      );

  Map<String, dynamic> toJson() => {
        "Nights": nights,
        "CityName": cityName,
      };
}
