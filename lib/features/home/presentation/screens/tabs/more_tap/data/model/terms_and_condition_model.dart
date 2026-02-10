class TermsAndConditionModel {
  TermsAndConditionModel({
      this.status, 
      this.message, 
      this.balance, 
      this.object, 
      this.obj,});

  TermsAndConditionModel.fromJson(dynamic json) {
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
      this.description,});

  Message.fromJson(dynamic json) {
    title = json['Title'];
    description = json['Description'];
  }
  String? title;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Title'] = title;
    map['Description'] = description;
    return map;
  }

}