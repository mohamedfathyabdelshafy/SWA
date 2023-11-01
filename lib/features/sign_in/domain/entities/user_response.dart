import 'package:equatable/equatable.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';

class UserResponse extends Equatable {
  final String? massage;
  final String? status;
  final User? user;
  final dynamic balance;
  final dynamic object;
  final dynamic obj;

  UserResponse({
    this.massage,
    this.status,
    this.user,
    this.balance,
    this.object,
    this.obj,
  });


  @override
  List<Object?> get props => [
    massage,
    status,
    user,
    balance,
    object,
    obj,
  ];
}