import 'package:equatable/equatable.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message.dart';

class PaymentMessageResponse extends Equatable {
  final String? message;
  final String? status;
  final PaymentMessage? paymentMessage;
  final dynamic balance;
  final dynamic object;
  final dynamic obj;

  const PaymentMessageResponse({
    this.message,
    this.status,
    this.paymentMessage,
    this.balance,
    this.object,
    this.obj,
  });


  @override
  List<Object?> get props => [
    message,
    status,
    balance,
    object,
    obj,
  ];
}

