class MyWalletResponseModel {
  MyWalletResponseModel({
      this.status, 
      this.message, 
      this.balance, 
      this.object, 
      this.obj,});

  MyWalletResponseModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
  String? status;
  double? message;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['balance'] = balance;
    map['Object'] = object;
    map['Obj'] = obj;
    return map;
  }

}