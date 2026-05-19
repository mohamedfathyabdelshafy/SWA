import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  MyWalletRepo myWalletRepo;
  PackagesRespo packagesRespo;
  WalletCubit(this.myWalletRepo, this.packagesRespo) : super(WalletState());

  void getUserWallet(
    int? customerId, {
    String? fromCurrency,
    String? toCurrency,
  }) async {
    if (customerId == null) return;
    emit(state.copyWith(status: WalletStatus.loading));
    try {
      final balance = await myWalletRepo.getMyWallet(customerId: customerId);

      double? convertedBalance;
      if (fromCurrency != null && toCurrency != null) {
        convertedBalance =
            await packagesRespo.Convertcurrency(from: fromCurrency, to: toCurrency, amount: state.walletBalance);
      }
      emit(state.copyWith(
        status: WalletStatus.success,
        walletBalance: convertedBalance ?? balance?.message,
      ));
    } catch (e) {
      emit(state.copyWith(status: WalletStatus.failure));
    }

    // void convertWalletBalance(String currency) {
    //   emit(state.copyWith(status: WalletStatus.loading));
    //   packagesRespo.Convertcurrency(from: Routes.curruncy, to: currency, amount: state.walletBalance)
    //       .then((value) => emit(state.copyWith(
    //             status: WalletStatus.success,
    //             walletBalance: value,
    //           )))
    //       .catchError((_) => emit(state.copyWith(status: WalletStatus.failure)));
    // }
  }
}
