// To parse this JSON data, do
//
//     final Packagemodel = PackagemodelFromJson(jsonString);

import 'dart:convert';

Packagemodel PackagemodelFromJson(String str) =>
    Packagemodel.fromJson(json.decode(str));

class Packagemodel {
  String? status;
  List<Message>? message;

  String? errormessage;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Packagemodel({
    this.status,
    this.message,
    this.errormessage,
    this.balance,
    this.object,
    this.obj,
  });

  Packagemodel.fromJson(dynamic json) {
    status = json["status"];

    if (status == 'success') {
      message =
          List<Message>.from(json["message"].map((x) => Message.fromJson(x)));
    } else {
      errormessage = json["message"];
    }

    balance = json["balance"];
    object = json["Object"];
    obj = json["Obj"];
  }
}

class Message {
  int? packageId;
  String? packageName;
  int? tripCount;
  double? packagePrice;
  String? fromDate;
  String? toDate;

  Message({
    this.packageId,
    this.packageName,
    this.tripCount,
    this.packagePrice,
    this.fromDate,
    this.toDate,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        packageId: json["PackageID"],
        packageName: json["PackageName"],
        tripCount: json["TripCount"],
        packagePrice: json["PackagePrice"],
        fromDate: json["FromDate"],
        toDate: json["ToDate"],
      );
}
