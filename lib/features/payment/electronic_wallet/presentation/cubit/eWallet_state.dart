part of 'eWallet_cubit.dart';

abstract class EWalletState {}

class EWalletInitial extends EWalletState {}

class EWalletLoadingState extends EWalletState {}

// EWallet States
class EWalletLoadedState extends EWalletState {
  final PaymentMessageResponse paymentMessageResponse;
  EWalletLoadedState({required this.paymentMessageResponse});
  // Equatable requires props, even if not explicitly defined in abstract class
  @override
  List<Object?> get props => [paymentMessageResponse];
}

// New states for various API response statuses
class EWalletConfirmationState extends EWalletState {
  final String message;
  EWalletConfirmationState({required this.message});
  @override
  List<Object?> get props => [message];
}

class EWalletWarningState extends EWalletState {
  final String message;
  EWalletWarningState({required this.message});
  @override
  List<Object?> get props => [message];
}

class EWalletImageState extends EWalletState {
  final String
      message; // This message should contain the image data (e.g., URL or base64)
  EWalletImageState({required this.message});
  @override
  List<Object?> get props => [message];
}

class EWalletImageWithGiftState extends EWalletState {
  final String
      message; // This message should contain the image data (e.g., URL or base64)
  EWalletImageWithGiftState({required this.message});
  @override
  List<Object?> get props => [message];
}

// Error States
class EWalletErrorState extends EWalletState {
  final Object error; // This could be a Failure object or a string
  EWalletErrorState({required this.error});
  // Equatable requires props, even if not explicitly defined in abstract class
  @override
  List<Object?> get props => [error]; // Use error in props for Equatable
}
