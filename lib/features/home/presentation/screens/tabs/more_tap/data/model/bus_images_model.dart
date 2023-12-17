class BusImagesModel {
  BusImagesModel({
      this.status, 
      this.message, 
      this.balance, 
      this.object, 
      this.obj,});

  BusImagesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'] != null ? Message.fromJson(json['message']) : null;
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
  String? status;
  Message? message;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (message != null) {
      map['message'] = message?.toJson();
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
      this.imagePaths,});

  Message.fromJson(dynamic json) {
    title = json['Title'];
    imagePaths = json['ImagePaths'] != null ? json['ImagePaths'].cast<String>() : [];
  }
  String? title;
  List<String>? imagePaths;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Title'] = title;
    map['ImagePaths'] = imagePaths;
    return map;
  }

}