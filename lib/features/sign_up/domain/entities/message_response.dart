import 'package:equatable/equatable.dart';

class MessageResponse extends Equatable {
  final int massage;
  final String? status;
  final dynamic balance;
  final dynamic object;
  final dynamic obj;

  const MessageResponse({
    required this.massage,
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