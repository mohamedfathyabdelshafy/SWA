class Accesspontmodel {
  Accesspontmodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.obj,
  });

  Accesspontmodel.fromJson(dynamic json) {
    status = json['status'];
    if (json['status'] == 'success') {
      message = Message.fromJson(json["message"]);
    } else {
      errormessage = json['message'];
    }
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
  String? status;
  Message? message;
  String? errormessage;

  dynamic balance;
  dynamic object;
  dynamic obj;
}

class Message {
  int? lineId;
  String? lineName;
  List<CityList>? cityList;

  Message({
    this.lineId,
    this.lineName,
    this.cityList,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        lineId: json["LineID"],
        lineName: json["LineName"],
        cityList: List<CityList>.from(
            json["CityList"].map((x) => CityList.fromJson(x))),
      );
}

class CityList {
  int? cityId;
  String? cityName;
  int? orderIndex;
  List<StationList>? stationList;

  CityList({
    this.cityId,
    this.cityName,
    this.orderIndex,
    this.stationList,
  });

  factory CityList.fromJson(Map<String, dynamic> json) => CityList(
        cityId: json["CityID"],
        cityName: json["CityName"],
        orderIndex: json["OrderIndex"],
        stationList: List<StationList>.from(
            json["StationList"].map((x) => StationList.fromJson(x))),
      );
}

class StationList {
  int? stationId;
  String? stationName;
  int? orderIndex;

  StationList({
    this.stationId,
    this.stationName,
    this.orderIndex,
  });

  factory StationList.fromJson(Map<String, dynamic> json) => StationList(
        stationId: json["StationID"],
        stationName: json["StationName"],
        orderIndex: json["OrderIndex"],
      );

  Map<String, dynamic> toJson() => {
        "StationID": stationId,
        "StationName": stationName,
        "OrderIndex": orderIndex,
      };
}
