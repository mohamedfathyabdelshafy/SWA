class LinesModel {
  LinesModel({
      this.status, 
      this.message, 
      this.balance, 
      this.object, 
      this.obj,});

  LinesModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message?.add(Message.fromJson(v));
      });
    }
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
  String? status;
  List<Message>? message;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (message != null) {
      map['message'] = message?.map((v) => v.toJson()).toList();
    }
    map['balance'] = balance;
    map['Object'] = object;
    map['Obj'] = obj;
    return map;
  }

}

class Message {
  Message({
      this.name, 
      this.nameAr, 
      this.nameEn, 
      this.lineID, 
      this.tripTypeId, 
      this.tripTypeName, 
      this.startsFrom,});

  Message.fromJson(dynamic json) {
    name = json['Name'];
    nameAr = json['NameAr'];
    nameEn = json['NameEn'];
    lineID = json['LineID'];
    tripTypeId = json['TripTypeId'];
    tripTypeName = json['TripTypeName'];
    startsFrom = json['StartsFrom'];
  }
  dynamic name;
  String? nameAr;
  String? nameEn;
  int? lineID;
  int? tripTypeId;
  String? tripTypeName;
  dynamic startsFrom;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = name;
    map['NameAr'] = nameAr;
    map['NameEn'] = nameEn;
    map['LineID'] = lineID;
    map['TripTypeId'] = tripTypeId;
    map['TripTypeName'] = tripTypeName;
    map['StartsFrom'] = startsFrom;
    return map;
  }

}