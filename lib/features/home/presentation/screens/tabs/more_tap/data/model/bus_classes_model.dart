class BusClassesModel {
  BusClassesModel({
      this.status, 
      this.message, 
      this.balance, 
      this.object, 
      this.obj,});

  BusClassesModel.fromJson(dynamic json) {
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
      this.title, 
      this.id,});

  Message.fromJson(dynamic json) {
    title = json['Title'];
    id = json['ID'];
  }
  String? title;
  int? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Title'] = title;
    map['ID'] = id;
    return map;
  }

}