import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  MyWalletRepo myWalletRepo;
  WalletCubit(this.myWalletRepo) : super(WalletState());

  void getUserWallet(int? customerId) {
    if (customerId == null) return;
    emit(state.copyWith(status: WalletStatus.loading));
    myWalletRepo
        .getMyWallet(customerId: customerId)
        .then((value) => emit(state.copyWith(
              status: WalletStatus.success,
              walletBalance: value?.message,
            )))
        .catchError((_) => emit(state.copyWith(status: WalletStatus.failure)));
  }
}
