import 'package:swa/features/sign_in/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String? token,
    required String? userId,
    required dynamic qRCode,
    required String? qRImg,
    required int? pinCode,
    required int? customerId,
    required bool? isActive,
    required double? walletBalance,
    required String? userName,
    required String? email,
    required String? name,
    required dynamic nameEn,
    required dynamic nameAr,
  }) : super(token: token, userId: userId, qRCode: qRCode, qRImg: qRImg, pinCode: pinCode, customerId: customerId, isActive: isActive, walletBalance: walletBalance, userName: userName, email: email, name: name, nameEn: nameEn, nameAr: nameAr);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      token : json['Token'],
      userId : json['UserId'],
      qRCode : json['QRCode'],
      qRImg : json['QRImg'],
      pinCode : json['PinCode'],
      customerId : json['CustomerId'],
      isActive : json['IsActive'],
      walletBalance : json['WalletBalance'],
      userName : json['userName'],
      email : json['Email'],
      name : json['Name'],
      nameEn : json['NameEn'],
      nameAr : json['NameAr'],
  );

  Map<String, dynamic> toJson() => {
    'Token' : token,
    'UserId' : userId ,
    'QRCode' : qRCode ,
    'QRImg' : qRImg ,
    'PinCode' : pinCode ,
    'CustomerId' : customerId ,
    'IsActive' : isActive ,
    'WalletBalance' : walletBalance ,
    'userName' : userName ,
    'Email' : email ,
    'Name' : name ,
    'NameEn' : nameEn ,
    'NameAr' : nameAr,
  };

}