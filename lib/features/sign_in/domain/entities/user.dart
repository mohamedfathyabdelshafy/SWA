import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? token;
  final String? userId;
  final dynamic qRCode;
  final String? qRImg;
  final int? pinCode;
  final int? customerId;
  final bool? isActive;
  final double? walletBalance;
  final String? userName;
  final String? email;
  final String? name;
  final dynamic nameEn;
  final dynamic nameAr;

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
    this.nameAr
  });


  @override
  List<Object?> get props => [
    token,
    userId,
    qRCode,
    qRImg,
    pinCode,
    customerId,
    isActive,
    walletBalance,
    userName,
    email,
    name,
    nameEn,
    nameAr
  ];
}