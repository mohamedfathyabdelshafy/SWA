// To parse this JSON data, do
//
//     final pagelistmodel = pagelistmodelFromJson(jsonString);

import 'dart:convert';

Pagelistmodel pagelistmodelFromJson(String str) =>
    Pagelistmodel.fromJson(json.decode(str));

class Pagelistmodel {
  String? status;
  List<Pagedata>? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  Pagelistmodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory Pagelistmodel.fromJson(Map<String, dynamic> json) => Pagelistmodel(
        status: json["status"],
        message: List<Pagedata>.from(
            json["message"].map((x) => Pagedata.fromJson(x))),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );
}

class Pagedata {
  int? pageId;
  int? orderIndex;
  String? pageName;
  String? image;
  String? description;
  bool? isComingSoon;
  bool? hasWalletBalance;

  Pagedata({
    this.pageId,
    this.orderIndex,
    this.pageName,
    this.image,
    this.description,
    this.isComingSoon,
    this.hasWalletBalance,
  });

  factory Pagedata.fromJson(Map<String, dynamic> json) => Pagedata(
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
