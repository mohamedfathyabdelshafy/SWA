// To parse this JSON data, do
//
//     final activePackagemodel = activePackagemodelFromJson(jsonString);

import 'dart:convert';

ActivePackagemodel activePackagemodelFromJson(String str) =>
    ActivePackagemodel.fromJson(json.decode(str));

class ActivePackagemodel {
  String? status;
  packages? message;
  String? errormessage;

  dynamic balance;
  dynamic object;
  dynamic obj;

  ActivePackagemodel({
    this.status,
    this.message,
    this.errormessage,
    this.balance,
    this.object,
    this.obj,
  });

  ActivePackagemodel.fromJson(dynamic json) {
    status = json["status"];

    if (json["status"] == 'success') {
      message = packages.fromJson(json["message"]);
    } else {
      errormessage = json["message"];
    }
    balance = json["balance"];
    object = json["Object"];
    obj = json["Obj"];
  }
}

class packages {
  int? packageId;
  String? packageName;
  int? tripCount;
  String? toDate;
  int? tripDone;
  int? remaingTrip;

  packages({
    this.packageId,
    this.packageName,
    this.tripCount,
    this.toDate,
    this.tripDone,
    this.remaingTrip,
  });

  packages.fromJson(Map<String, dynamic> json) {
    packageId = json["PackageID"];
    packageName = json["PackageName"];
    tripCount = json["TripCount"];
    toDate = json["ToDate"];
    tripDone = json["TripDone"];
    remaingTrip = json["RemaingTrip"];
  }
}
