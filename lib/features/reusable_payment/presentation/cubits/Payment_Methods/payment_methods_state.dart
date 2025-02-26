// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_methods_cubit.dart';

class PaymentMethodsState extends Equatable {
  final PaymentMethodsStatus status;
  final PaymentMethodsStatus walletBalanceStatus;
  final List<PaymentMethod> paymentMethods;
  final String errorMessage;
  final num walletBalance;
  const PaymentMethodsState({
    this.status = PaymentMethodsStatus.initial,
    this.walletBalanceStatus = PaymentMethodsStatus.initial,
    this.paymentMethods = const [],
    this.errorMessage = '',
    this.walletBalance = 0,
  });

  @override
  List<Object> get props => [
        status,
        paymentMethods,
        errorMessage,
        walletBalance,
        walletBalanceStatus
      ];

  PaymentMethodsState copyWith({
    PaymentMethodsStatus? status,
    List<PaymentMethod>? paymentMethods,
    String? errorMessage,
    num? walletBalance,
    PaymentMethodsStatus? walletBalanceStatus,
  }) {
    return PaymentMethodsState(
      status: status ?? this.status,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      errorMessage: errorMessage ?? this.errorMessage,
      walletBalance: walletBalance ?? this.walletBalance,
      walletBalanceStatus: walletBalanceStatus ?? this.walletBalanceStatus,
    );
  }
}

enum PaymentMethodsStatus { success, failure, loading, initial }

extension PaymentMethodsStatusX on PaymentMethodsState {
  bool get isLoading => status == PaymentMethodsStatus.loading;
  bool get isSuccess => status == PaymentMethodsStatus.success;
  bool get isFailure => status == PaymentMethodsStatus.failure;

  bool get isWalletBalanceLoading =>
      walletBalanceStatus == PaymentMethodsStatus.loading;
  bool get isWalletBalanceSuccess =>
      walletBalanceStatus == PaymentMethodsStatus.success;
  bool get isWalletBalanceFailure =>
      walletBalanceStatus == PaymentMethodsStatus.failure;
}
