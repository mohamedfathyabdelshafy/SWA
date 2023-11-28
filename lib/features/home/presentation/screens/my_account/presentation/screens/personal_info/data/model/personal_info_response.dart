class PersonalInfoResponse {
  PersonalInfoResponse({
      this.status, 
      this.personalInfo,
      this.balance, 
      this.object, 
      this.obj,});

  PersonalInfoResponse.fromJson(dynamic json) {
    status = json['status'];
    personalInfo = json['message'] != null ? PersonalInfo.fromJson(json['message']) : null;
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
  String? status;
  PersonalInfo? personalInfo;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (personalInfo != null) {
      map['message'] = personalInfo?.toJson();
    }
    map['balance'] = balance;
    map['Object'] = object;
    map['Obj'] = obj;
    return map;
  }

}

class PersonalInfo {
  PersonalInfo({
      this.customerID, 
      this.name, 
      this.mobile, 
      this.mobile2, 
      this.email, 
      this.userLogInID, 
      this.phone, 
      this.address, 
      this.walletBalance,});

  PersonalInfo.fromJson(dynamic json) {
    customerID = json['CustomerID'];
    name = json['Name'];
    mobile = json['Mobile'];
    mobile2 = json['Mobile2'];
    email = json['Email'];
    userLogInID = json['UserLogInID'];
    phone = json['Phone'];
    address = json['Address'];
    walletBalance = json['WalletBalance'];
  }
  int? customerID;
  String? name;
  String? mobile;
  dynamic mobile2;
  String? email;
  dynamic userLogInID;
  dynamic phone;
  dynamic address;
  dynamic walletBalance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CustomerID'] = customerID;
    map['Name'] = name;
    map['Mobile'] = mobile;
    map['Mobile2'] = mobile2;
    map['Email'] = email;
    map['UserLogInID'] = userLogInID;
    map['Phone'] = phone;
    map['Address'] = address;
    map['WalletBalance'] = walletBalance;
    return map;
  }

}