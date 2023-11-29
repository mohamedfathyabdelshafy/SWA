import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/payment/electronic_wallet/domain/use_cases/ewallet_use_case.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';

abstract class EWalletPaymentRepository {
  Future<Either<Failure, PaymentMessageResponse>> eWalletPayment(
      EWalletParams params);
}
