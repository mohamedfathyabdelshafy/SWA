// To parse this JSON data, do
//
//     final selectappmodel = selectappmodelFromJson(jsonString);

import 'dart:convert';

Selectappmodel selectappmodelFromJson(String str) =>
    Selectappmodel.fromJson(json.decode(str));

class Selectappmodel {
  String? status;
  Message? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  Selectappmodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory Selectappmodel.fromJson(Map<String, dynamic> json) => Selectappmodel(
        status: json["status"],
        message: Message.fromJson(json["message"]),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );
}

class Message {
  String? title;
  List<AppList>? appList;

  Message({
    this.title,
    this.appList,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        title: json["Title"],
        appList:
            List<AppList>.from(json["AppList"].map((x) => AppList.fromJson(x))),
      );
}

class AppList {
  String? image;
  String? description;
  int? orderIndex;

  AppList({
    this.image,
    this.description,
    this.orderIndex,
  });

  factory AppList.fromJson(Map<String, dynamic> json) => AppList(
        image: json["Image"],
        description: json["Description"],
        orderIndex: json["OrderIndex"],
      );

  Map<String, dynamic> toJson() => {
        "Image": image,
        "Description": description,
        "OrderIndex": orderIndex,
      };
}
