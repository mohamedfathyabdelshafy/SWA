// To parse this JSON data, do
//
//     final promocodemodel = promocodemodelFromJson(jsonString);

import 'dart:convert';

Promocodemodel promocodemodelFromJson(String str) =>
    Promocodemodel.fromJson(json.decode(str));

class Promocodemodel {
  String? status;
  Message? message;
  String? errormessage;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Promocodemodel({
    this.status,
    this.message,
    this.errormessage,
    this.balance,
    this.object,
    this.obj,
  });

  Promocodemodel.fromJson(Map<String, dynamic> json) {
    status = json["status"];

    if (json['status'] == 'success') {
      message = Message.fromJson(json["message"]);
    } else {
      errormessage = json['message'];
    }
    balance = json["balance"];
    object = json["Object"];
    obj = json["Obj"];
  }
}

class Message {
  bool? isPrecentage;
  double? discount;
  int? promoCodeId;

  Message({
    this.isPrecentage,
    this.discount,
    this.promoCodeId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        isPrecentage: json["IsPrecentage"],
        discount: json["Discount"],
        promoCodeId: json["PromoCodeID"],
      );

  Map<String, dynamic> toJson() => {
        "IsPrecentage": isPrecentage,
        "Discount": discount,
        "PromoCodeID": promoCodeId,
      };
}
