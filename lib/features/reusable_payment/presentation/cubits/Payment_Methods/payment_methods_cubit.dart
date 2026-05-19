import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/features/reusable_payment/data/models/payment_method.dart';
import 'package:swa/features/reusable_payment/data/repo/payment_methods_repo.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final PaymentMethodsRepo _paymentMethodsRepo;
  final MyWalletRepo _myWalletRepo;
  PaymentMethodsCubit(this._paymentMethodsRepo, this._myWalletRepo)
      : super(PaymentMethodsState());

  void init() {
    getPaymentMethods();
    getWalletBalance();
  }

  Future<void> getPaymentMethods() async {
    emit(state.copyWith(status: PaymentMethodsStatus.loading));
    try {
      final paymentMethods = await _paymentMethodsRepo.getPaymentMethods();
      emit(state.copyWith(
        status: PaymentMethodsStatus.success,
        paymentMethods: paymentMethods,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PaymentMethodsStatus.failure,
      ));
    }
  }

  Future getWalletBalance() async {
    emit(state.copyWith(status: PaymentMethodsStatus.loading));
    try {
      final walletBalance = await _myWalletRepo.getMyWallet(
        //TODO reverse this
        customerId: 4,
        //  Routes.customerid!
      );

      emit(state.copyWith(
        status: PaymentMethodsStatus.success,
        walletBalance: walletBalance?.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PaymentMethodsStatus.failure,
      ));
    }
  }
}
