import 'package:swa/features/sign_in/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.token,
    required super.userId,
    required super.qRCode,
    required super.qRImg,
    required super.pinCode,
    required super.customerId,
    required super.isActive,
    required super.walletBalance,
    required super.userName,
    required super.email,
    required super.name,
    required super.nameEn,
    required super.nameAr,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json['Token'],
        userId: json['UserId'],
        qRCode: json['QRCode'],
        qRImg: json['QRImg'],
        pinCode: json['PinCode'],
        customerId: json['CustomerId'],
        isActive: json['IsActive'],
        walletBalance: json['WalletBalance'],
        userName: json['userName'],
        email: json['Email'],
        name: json['Name'],
        nameEn: json['NameEn'],
        nameAr: json['NameAr'],
      );

  Map<String, dynamic> toJson() => {
        'Token': token,
        'UserId': userId,
        'QRCode': qRCode,
        'QRImg': qRImg,
        'PinCode': pinCode,
        'CustomerId': customerId,
        'IsActive': isActive,
        'WalletBalance': walletBalance,
        'userName': userName,
        'Email': email,
        'Name': name,
        'NameEn': nameEn,
        'NameAr': nameAr,
      };
}
