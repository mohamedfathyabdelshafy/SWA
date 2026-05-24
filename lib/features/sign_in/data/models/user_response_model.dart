import 'package:swa/features/sign_in/data/models/user_model.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/domain/entities/user_response.dart';

class UserResponseModel extends UserResponse {
  const UserResponseModel({
    required super.massage,
    required super.status,
    required super.user,
    required super.balance,
    required super.object,
    required super.obj,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        status: json['status'],
        massage: (json['status'] == 'failed') ? json['message'] : null,
        user: (json['message'] != null && json['status'] != 'failed')
            ? UserModel.fromJson(json['message'])
            : null,
        balance: json['balance'],
        object: json['Object'],
        obj: json['Obj'],
      );

  Map<String, dynamic> toJson() => {
        // 'message' : massage,
        'status': status,
        'message': (status == 'failed')
            ? massage
            : UserModel(
                    token: user?.token,
                    userId: user?.userId,
                    qRCode: user?.qRCode,
                    qRImg: user?.qRImg,
                    pinCode: user?.pinCode,
                    customerId: user?.customerId,
                    isActive: user?.isActive,
                    walletBalance: user?.walletBalance,
                    userName: user?.userName,
                    email: user?.email,
                    name: user?.name,
                    nameEn: user?.nameEn,
                    nameAr: user?.nameAr)
                .toJson(), //user?.toJson(),
        'balance': balance,
        'Object': object,
        'Obj': obj,
      };
}
