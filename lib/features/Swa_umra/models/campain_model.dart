// To parse this JSON data, do
//
//     final campainModel = campainModelFromJson(jsonString);

import 'dart:convert';

CampainModel campainModelFromJson(String str) =>
    CampainModel.fromJson(json.decode(str));

class CampainModel {
  String? status;
  Campain? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  CampainModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory CampainModel.fromJson(Map<String, dynamic> json) => CampainModel(
        status: json["status"],
        message: Campain.fromJson(json["message"]),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );
}

class Campain {
  List<ListElement>? list;

  Campain({
    this.list,
  });

  factory Campain.fromJson(Map<String, dynamic> json) => Campain(
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
  List<DetailsList>? detailsList;
  dynamic image;

  ListElement({
    this.campiagnUmraId,
    this.name,
    this.isActive,
    this.isDelete,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.detailsList,
    this.image,
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
        detailsList: List<DetailsList>.from(
            json["DetailsList"].map((x) => DetailsList.fromJson(x))),
        image: json["Image"],
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
