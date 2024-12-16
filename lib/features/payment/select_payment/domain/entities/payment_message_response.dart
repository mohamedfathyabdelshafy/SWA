import 'package:equatable/equatable.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message.dart';

class PaymentMessageResponse extends Equatable {
  final String? message;
  final String? status;
  final PaymentMessage? paymentMessage;
  final dynamic balance;
  final dynamic object;
  final dynamic obj;

  final dynamic text;

  const PaymentMessageResponse(
      {this.message,
      this.status,
      this.paymentMessage,
      this.balance,
      this.object,
      this.obj,
      this.text});

  @override
  List<Object?> get props => [message, status, balance, object, obj, text];
}
