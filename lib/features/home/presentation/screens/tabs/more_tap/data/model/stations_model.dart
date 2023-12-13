class StationsModel {
  StationsModel({
      this.status, 
      this.message, 
      this.balance, 
      this.object, 
      this.obj,});

  StationsModel.fromJson(dynamic json) {
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
      this.cityName, 
      this.stationName,});

  Message.fromJson(dynamic json) {
    cityName = json['CityName'];
    stationName = json['StationName'];
  }
  String? cityName;
  String? stationName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CityName'] = cityName;
    map['StationName'] = stationName;
    return map;
  }

}