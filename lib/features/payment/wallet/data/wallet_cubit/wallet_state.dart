// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'wallet_cubit.dart';

class WalletState {
  final WalletStatus status;
  final double? walletBalance;
  final String? errorMessage;
  const WalletState({
    this.status = WalletStatus.initial,
    this.walletBalance,
    this.errorMessage,
  });

  WalletState copyWith({
    WalletStatus? status,
    double? walletBalance,
    String? errorMessage,
  }) {
    return WalletState(
      status: status ?? this.status,
      walletBalance: walletBalance ?? this.walletBalance,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(covariant WalletState other) {
    if (identical(this, other)) return true;

    return other.status == status && other.walletBalance == walletBalance && other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => status.hashCode ^ walletBalance.hashCode ^ errorMessage.hashCode;
}

enum WalletStatus { success, failure, loading, initial }

extension WalletStatusX on WalletState {
  bool get isLoading => status == WalletStatus.loading;
  bool get isSuccess => status == WalletStatus.success;
  bool get isFailure => status == WalletStatus.failure;
}
