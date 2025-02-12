// To parse this JSON data, do
//
//     final curruncylist = curruncylistFromJson(jsonString);

import 'dart:convert';

Curruncylist curruncylistFromJson(String str) =>
    Curruncylist.fromJson(json.decode(str));

String curruncylistToJson(Curruncylist data) => json.encode(data.toJson());

class Curruncylist {
  String? status;
  List<Message>? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  Curruncylist({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory Curruncylist.fromJson(Map<String, dynamic> json) => Curruncylist(
        status: json["status"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": List<dynamic>.from(message!.map((x) => x.toJson())),
        "balance": balance,
        "Object": object,
        "Text": text,
        "Obj": obj,
      };
}

class Message {
  int? currencyId;
  int? code;
  String? name;
  String? symbol;
  dynamic unitName;

  Message({
    this.currencyId,
    this.code,
    this.name,
    this.symbol,
    this.unitName,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        currencyId: json["CurrencyID"],
        code: json["Code"],
        name: json["Name"],
        symbol: json["Symbol"],
        unitName: json["UnitName"],
      );

  Map<String, dynamic> toJson() => {
        "CurrencyID": currencyId,
        "Code": code,
        "Name": name,
        "Symbol": symbol,
        "UnitName": unitName,
      };
}
