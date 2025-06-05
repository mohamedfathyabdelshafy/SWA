import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/payment/electronic_wallet/domain/repositories/eWallet_repository.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';

class EWalletUseCase implements UseCase<PaymentMessageResponse, EWalletParams>{
  final EWalletPaymentRepository eWalletPaymentRepository;
  EWalletUseCase({required this.eWalletPaymentRepository});

  @override
  Future<Either<Failure, PaymentMessageResponse>> call(EWalletParams params) {
    return eWalletPaymentRepository.eWalletPayment(params);
  }
}

class EWalletParams extends Equatable{
  final String customerId;
  final String mobileNumber;
  final String amount;
  const EWalletParams({required this.customerId, required this.amount, required this.mobileNumber});

  @override
  List<Object?> get props => [customerId, amount, mobileNumber];
}