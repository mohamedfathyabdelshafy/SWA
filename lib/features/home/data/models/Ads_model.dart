// To parse this JSON data, do
//
//     final advModel = advModelFromJson(jsonString);

import 'dart:convert';

AdvModel advModelFromJson(String str) => AdvModel.fromJson(json.decode(str));

class AdvModel {
  String? status;
  List<Message>? message;
  String? eroormessage;

  dynamic balance;
  dynamic object;
  dynamic obj;

  AdvModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.obj,
  });

  AdvModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];

    if (json["status"] == 'success') {
      message =
          List<Message>.from(json["message"].map((x) => Message.fromJson(x)));
    } else {
      eroormessage = json["message"];
    }

    balance = json["balance"];
    object = json["Object"];
    obj = json["Obj"];
  }
}

class Message {
  int? adCustomerAppWebViewId;
  dynamic textAr;
  dynamic textEn;
  DateTime? displayDateFrom;
  DateTime? displayDateTo;
  dynamic photoFile;
  String? filePath;
  String? fullImagePath;
  bool? isDelete;
  dynamic createdBy;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  dynamic linkApi;
  String? icon;
  int? numberViews;
  dynamic cityId;
  dynamic countryId;
  dynamic packageId;
  dynamic creationDateFrom;
  dynamic creationDateTo;

  Message({
    this.adCustomerAppWebViewId,
    this.textAr,
    this.textEn,
    this.displayDateFrom,
    this.displayDateTo,
    this.photoFile,
    this.filePath,
    this.fullImagePath,
    this.isDelete,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.linkApi,
    this.icon,
    this.numberViews,
    this.cityId,
    this.countryId,
    this.packageId,
    this.creationDateFrom,
    this.creationDateTo,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        adCustomerAppWebViewId: json["ADCustomerAppWebViewID"],
        textAr: json["TextAr"],
        textEn: json["TextEn"],
        displayDateFrom: DateTime.parse(json["DisplayDateFrom"]),
        displayDateTo: DateTime.parse(json["DisplayDateTo"]),
        photoFile: json["PhotoFile"],
        filePath: json["FilePath"],
        fullImagePath: json["FullImagePath"],
        isDelete: json["IsDelete"],
        createdBy: json["CreatedBy"],
        creationDate: DateTime.parse(json["CreationDate"]),
        updatedBy: json["UpdatedBy"],
        updateDate: json["UpdateDate"],
        linkApi: json["LinkAPI"],
        icon: json["Icon"],
        numberViews: json["NumberViews"],
        cityId: json["CityID"],
        countryId: json["CountryID"],
        packageId: json["PackageID"],
        creationDateFrom: json["CreationDateFrom"],
        creationDateTo: json["CreationDateTo"],
      );
}
