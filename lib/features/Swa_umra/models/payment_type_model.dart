// To parse this JSON data, do
//
//     final paymenttypemodel = paymenttypemodelFromJson(jsonString);

import 'dart:convert';

Paymenttypemodel paymenttypemodelFromJson(String str) =>
    Paymenttypemodel.fromJson(json.decode(str));

class Paymenttypemodel {
  String? status;
  List<paymentbody>? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  Paymenttypemodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory Paymenttypemodel.fromJson(Map<String, dynamic> json) =>
      Paymenttypemodel(
        status: json["status"],
        message: List<paymentbody>.from(
            json["message"].map((x) => paymentbody.fromJson(x))),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );
}

class paymentbody {
  int? pageId;
  int? orderIndex;
  String? pageName;
  String? image;
  String? description;
  bool? isComingSoon;
  bool? hasWalletBalance;

  paymentbody({
    this.pageId,
    this.orderIndex,
    this.pageName,
    this.image,
    this.description,
    this.isComingSoon,
    this.hasWalletBalance,
  });

  factory paymentbody.fromJson(Map<String, dynamic> json) => paymentbody(
        pageId: json["PageID"],
        orderIndex: json["OrderIndex"],
        pageName: json["PageName"],
        image: json["Image"],
        description: json["Description"],
        isComingSoon: json["IsComingSoon"],
        hasWalletBalance: json["HasWalletBalance"],
      );

  Map<String, dynamic> toJson() => {
        "PageID": pageId,
        "OrderIndex": orderIndex,
        "PageName": pageName,
        "Image": image,
        "Description": description,
        "IsComingSoon": isComingSoon,
        "HasWalletBalance": hasWalletBalance,
      };
}
