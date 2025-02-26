// To parse this JSON data, do
//
//     final programsModel = programsModelFromJson(jsonString);

import 'dart:math' as math;

import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';

ProgramsModel programsModelFromJson(String str) => ProgramsModel.fromJson(json.decode(str));

class ProgramsModel {
  String? status;
  List<Programsdetails>? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  ProgramsModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory ProgramsModel.fromJson(Map<String, dynamic> json) => ProgramsModel(
        status: json["status"],
        message: List<Programsdetails>.from(json["message"].map((x) => Programsdetails.fromJson(x))),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );

  factory ProgramsModel.dummy() {
    return ProgramsModel(
      status: "success",
      message: [
        Programsdetails.dummy(isRequired: true, personCountReserved: 1),
        Programsdetails.dummy(isRequired: false, personCountReserved: 1),
        Programsdetails.dummy(isRequired: false, personCountReserved: 3),
        Programsdetails.dummy(isRequired: true, personCountReserved: 3),
      ],
      balance: 100,
      object: 1,
      text: "text",
      obj: 1,
    );
  }
}

class Programsdetails {
  int? tripUnrahProgramId;
  int? tripUmrahId;
  List<String>? description;
  bool? isMain;
  dynamic price;
  bool? isDeleted;
  bool? isActive;
  dynamic createdBy;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updatedDated;
  bool? isRequired;
  dynamic moreLink;
  bool? withMoreLink;
  String? title;
  String? image;
  dynamic priceBeforeDiscount;
  dynamic discount;
  bool? isreserved;
  int? personCountReserved;

  Programsdetails({
    this.tripUnrahProgramId,
    this.tripUmrahId,
    this.description,
    this.isMain,
    this.price,
    this.isDeleted,
    this.isActive,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updatedDated,
    this.isRequired,
    this.moreLink,
    this.withMoreLink,
    this.title,
    this.image,
    this.priceBeforeDiscount,
    this.discount,
    this.isreserved,
    this.personCountReserved,
  });
  factory Programsdetails.dummy({required bool isRequired, required int personCountReserved}) {
    return Programsdetails(
      tripUnrahProgramId: 1,
      tripUmrahId: 1,
      description: ["description"],
      isMain: true,
      price: 100,
      isDeleted: false,
      isActive: true,
      createdBy: 1,
      creationDate: DateTime.now(),
      updatedBy: 1,
      updatedDated: DateTime.now(),
      isRequired: isRequired,
      moreLink: null,
      withMoreLink: false,
      title: "title",
      image: "image",
      priceBeforeDiscount: 100,
      discount: 10,
      isreserved: false,
      personCountReserved: personCountReserved,
    );
  }
  factory Programsdetails.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();

    return Programsdetails(
      tripUnrahProgramId: json["TripUnrahProgramID"],
      tripUmrahId: json["TripUmrahID"],
      description: List<String>.from(json["Description"].map((x) => unescape.convert(x))),
      isMain: json["IsMain"],
      price: json["Price"],
      isDeleted: json["IsDeleted"],
      isActive: json["IsActive"],
      createdBy: json["CreatedBy"],
      creationDate: DateTime.parse(json["CreationDate"]),
      updatedBy: json["UpdatedBy"],
      updatedDated: json["UpdatedDated"],
      isRequired: json["IsRequired"],
      moreLink: json["MoreLink"],
      withMoreLink: json["WithMoreLink"],
      title: (json["Title"] ?? "").isEmpty ? null : unescape.convert(json["Title"]),
      image: json["Image"],
      priceBeforeDiscount: json["PriceBeforeDiscount"],
      discount: json["Discount"],
      isreserved: json["Isreserved"],
      personCountReserved: json["PersonCountReserved"],
    );
  }
}
