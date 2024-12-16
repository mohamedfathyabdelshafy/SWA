// To parse this JSON data, do
//
//     final tripUmramodel = tripUmramodelFromJson(jsonString);

import 'dart:convert';

TripUmramodel tripUmramodelFromJson(String str) =>
    TripUmramodel.fromJson(json.decode(str));

class TripUmramodel {
  String? status;
  Message? message;
  String? errormessage;

  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  TripUmramodel({
    this.status,
    this.message,
    this.balance,
    this.errormessage,
    this.object,
    this.text,
    this.obj,
  });

  TripUmramodel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    if (json['status'] == 'success') {
      message = Message.fromJson(json["message"]);
    } else {
      errormessage = json['message'];
    }
    balance = json["balance"];
    object = json["Object"];
    text = json["Text"];
    obj = json["Obj"];
  }
}

class Message {
  List<ListElement>? list;

  Message({
    this.list,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        list: List<ListElement>.from(
            json["List"].map((x) => ListElement.fromJson(x))),
      );
}

class ListElement {
  int? tripUmraTypeId;
  String? name;
  String? description;
  dynamic createdBy;
  DateTime? creationDate;
  dynamic updatedBy;
  dynamic updateDate;
  bool? isDelete;
  bool? isActive;

  ListElement({
    this.tripUmraTypeId,
    this.name,
    this.description,
    this.createdBy,
    this.creationDate,
    this.updatedBy,
    this.updateDate,
    this.isDelete,
    this.isActive,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        tripUmraTypeId: json["TripUmraTypeID"],
        name: json["Name"],
        description: json["Description"],
        createdBy: json["CreatedBy"],
        creationDate: DateTime.parse(json["CreationDate"]),
        updatedBy: json["UpdatedBy"],
        updateDate: json["UpdateDate"],
        isDelete: json["IsDelete"],
        isActive: json["IsActive"],
      );
}
