part of 'eWallet_cubit.dart';

abstract class EWalletState {}

class EWalletInitial extends EWalletState {}

class EWalletLoadingState extends EWalletState {}
//EWallet States
class EWalletLoadedState extends EWalletState {
  final PaymentMessageResponse paymentMessageResponse;
  EWalletLoadedState({required this.paymentMessageResponse});
  List<Object> get props => [paymentMessageResponse];
}
//Error States
class EWalletErrorState extends EWalletState {
  final Object error;
  EWalletErrorState({required this.error});
  Object get props => error;
}