// To parse this JSON data, do
//
//     final stationfromModel = stationfromModelFromJson(jsonString);

import 'dart:convert';

StationfromModel stationfromModelFromJson(String str) =>
    StationfromModel.fromJson(json.decode(str));

class StationfromModel {
  String? status;
  List<Message>? message;
  dynamic balance;
  dynamic object;
  dynamic obj;

  StationfromModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.obj,
  });

  factory StationfromModel.fromJson(Map<String, dynamic> json) =>
      StationfromModel(
        status: json["status"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
        balance: json["balance"],
        object: json["Object"],
        obj: json["Obj"],
      );
}

class Message {
  int? cityId;
  String? cityName;
  List<StationList>? stationList;

  Message({
    this.cityId,
    this.cityName,
    this.stationList,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        cityId: json["CityID"],
        cityName: json["CityName"],
        stationList: List<StationList>.from(
            json["StationList"].map((x) => StationList.fromJson(x))),
      );
}

class StationList {
  int? stationId;
  String? stationName;

  StationList({
    this.stationId,
    this.stationName,
  });

  factory StationList.fromJson(Map<String, dynamic> json) => StationList(
        stationId: json["StationId"],
        stationName: json["StationName"],
      );

  Map<String, dynamic> toJson() => {
        "StationId": stationId,
        "StationName": stationName,
      };
}
