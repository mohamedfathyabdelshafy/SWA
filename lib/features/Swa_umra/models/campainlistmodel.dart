// To parse this JSON data, do
//
//     final campainlistmodel = campainlistmodelFromJson(jsonString);

import 'dart:convert';

Campainlistmodel campainlistmodelFromJson(String str) =>
    Campainlistmodel.fromJson(json.decode(str));

class Campainlistmodel {
  String? status;
  Campainlis? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  Campainlistmodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory Campainlistmodel.fromJson(Map<String, dynamic> json) =>
      Campainlistmodel(
        status: json["status"],
        message: Campainlis.fromJson(json["message"]),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );
}

class Campainlis {
  List<ListElement>? list;

  Campainlis({
    this.list,
  });

  factory Campainlis.fromJson(Map<String, dynamic> json) => Campainlis(
        list: List<ListElement>.from(
            json["List"].map((x) => ListElement.fromJson(x))),
      );
}

class ListElement {
  int? campiagnUmraId;
  String? name;
  bool? isActive;
  bool? isDelete;
  dynamic createdBy;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  List<dynamic>? tripList;
  dynamic nightList;
  dynamic detailsList;
  String? image;
  dynamic bgColor;
  dynamic tripDate;
  dynamic tripTime;
  int? availability;
  bool? withTransportation;
  bool? isRequired;
  dynamic accommodationType;

  ListElement({
    this.campiagnUmraId,
    this.name,
    this.isActive,
    this.isDelete,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.tripList,
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
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
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
            : List<dynamic>.from(json["TripList"].map((x) => x)),
        nightList: json["NightList"],
        detailsList: json["DetailsList"],
        image: json["Image"],
        bgColor: json["BgColor"],
        tripDate: json["TripDate"],
        tripTime: json["TripTime"],
        availability: json["Availability"],
        withTransportation: json["WithTransportation"],
        isRequired: json["IsRequired"],
        accommodationType: json["AccommodationType"],
      );
}
