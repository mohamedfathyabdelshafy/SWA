// To parse this JSON data, do
//
//     final adsModel = adsModelFromJson(jsonString);

import 'dart:convert';

AdsModel adsModelFromJson(String str) => AdsModel.fromJson(json.decode(str));

class AdsModel {
  String? status;
  List<Advertisement>? message;
  String? errormessage;
  dynamic balance;
  dynamic object;
  dynamic obj;

  AdsModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.errormessage,
    this.obj,
  });

  AdsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    if (json["status"] == 'success') {
      message = List<Advertisement>.from(
          json["message"].map((x) => Advertisement.fromJson(x)));
    } else {
      errormessage = json["message"];
    }

    balance = json["balance"];
    object = json["Object"];
    obj = json["Obj"];
  }
}

class Advertisement {
  int adAppId;
  dynamic textAr;
  dynamic textEn;
  DateTime displayDateFrom;
  DateTime displayDateTo;
  String filePath;
  bool isDelete;
  String createdBy;
  DateTime creationDate;
  String updatedBy;
  DateTime updateDate;
  dynamic linkApi;
  String icon;

  Advertisement({
    required this.adAppId,
    required this.textAr,
    required this.textEn,
    required this.displayDateFrom,
    required this.displayDateTo,
    required this.filePath,
    required this.isDelete,
    required this.createdBy,
    required this.creationDate,
    required this.updatedBy,
    required this.updateDate,
    required this.linkApi,
    required this.icon,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
        adAppId: json["ADAppID"],
        textAr: json["TextAr"],
        textEn: json["TextEn"],
        displayDateFrom: DateTime.parse(json["DisplayDateFrom"]),
        displayDateTo: DateTime.parse(json["DisplayDateTo"]),
        filePath: json["FilePath"],
        isDelete: json["IsDelete"],
        createdBy: json["CreatedBy"],
        creationDate: DateTime.parse(json["CreationDate"]),
        updatedBy: json["UpdatedBy"],
        updateDate: DateTime.parse(json["UpdateDate"]),
        linkApi: json["LinkAPI"],
        icon: json["Icon"],
      );

  Map<String, dynamic> toJson() => {
        "ADAppID": adAppId,
        "TextAr": textAr,
        "TextEn": textEn,
        "DisplayDateFrom": displayDateFrom.toIso8601String(),
        "DisplayDateTo": displayDateTo.toIso8601String(),
        "FilePath": filePath,
        "IsDelete": isDelete,
        "CreatedBy": createdBy,
        "CreationDate": creationDate.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdateDate": updateDate.toIso8601String(),
        "LinkAPI": linkApi,
        "Icon": icon,
      };
}
