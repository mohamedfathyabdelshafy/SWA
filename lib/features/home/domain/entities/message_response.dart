import 'package:equatable/equatable.dart';

class HomeMessageResponse extends Equatable {
  final String? massage;
  final String? status;
  final dynamic balance;
  final dynamic object;
  final dynamic obj;

  const HomeMessageResponse({
    this.massage,
    this.status,
    this.balance,
    this.object,
    this.obj,
  });


  @override
  List<Object?> get props => [
    massage,
    status,
    balance,
    object,
    obj,
  ];
}