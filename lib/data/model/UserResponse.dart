class UserResponse {
  UserResponse({
      this.status, 
      this.user,
      this.balance, 
      this.object, 
      this.obj,
  this.massage,});

  UserResponse.fromJson(dynamic json) {
    status = json['status'];
   // massage = json['message'];
    user = json['message'] != null ? User.fromJson(json['message']) : null;
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
  String? massage;
  String? status;
  User? user;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = massage;
    map['status'] = status;
    if (user != null) {
      map['message'] = user?.toJson();
    }
    map['balance'] = balance;
    map['Object'] = object;
    map['Obj'] = obj;
    return map;
  }

}

class User {
  User({
      this.token, 
      this.userId, 
      this.qRCode, 
      this.qRImg, 
      this.pinCode, 
      this.customerId, 
      this.isActive, 
      this.walletBalance, 
      this.userName, 
      this.email, 
      this.name, 
      this.nameEn, 
      this.nameAr,});

  User.fromJson(dynamic json) {
    token = json['Token'];
    userId = json['UserId'];
    qRCode = json['QRCode'];
    qRImg = json['QRImg'];
    pinCode = json['PinCode'];
    customerId = json['CustomerId'];
    isActive = json['IsActive'];
    walletBalance = json['WalletBalance'];
    userName = json['userName'];
    email = json['Email'];
    name = json['Name'];
    nameEn = json['NameEn'];
    nameAr = json['NameAr'];
  }
  String? token;
  String? userId;
  dynamic qRCode;
  String? qRImg;
  int? pinCode;
  int? customerId;
  bool? isActive;
  double? walletBalance;
  String? userName;
  String? email;
  String? name;
  dynamic nameEn;
  dynamic nameAr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Token'] = token;
    map['UserId'] = userId;
    map['QRCode'] = qRCode;
    map['QRImg'] = qRImg;
    map['PinCode'] = pinCode;
    map['CustomerId'] = customerId;
    map['IsActive'] = isActive;
    map['WalletBalance'] = walletBalance;
    map['userName'] = userName;
    map['Email'] = email;
    map['Name'] = name;
    map['NameEn'] = nameEn;
    map['NameAr'] = nameAr;
    return map;
  }

}