import 'package:equatable/equatable.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Reservation_Response_fawry_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Electronic_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_response_MyWallet_model.dart';

abstract class ReservationStates extends Equatable {}

class LoadingMyWalletState extends ReservationStates {
  List<Object?> get props => [];
}

class InitialReservationStates extends ReservationStates {
  @override
  List<Object?> get props => [];
}

class LoadedMyWalletState extends ReservationStates {
  ReservationResponseMyWalletModel reservationResponseMyWalletModel;
  LoadedMyWalletState({required this.reservationResponseMyWalletModel});
  List<Object?> get props => [];
}

class ErrorMyWalletState extends ReservationStates {
  String error;
  ErrorMyWalletState({required this.error});
  List<Object?> get props => [];
}

// New states for MyWallet
class ConfirmationMyWalletState extends ReservationStates {
  final String message;
  ConfirmationMyWalletState({required this.message});
  @override
  List<Object?> get props => [message];
}

class WarningMyWalletState extends ReservationStates {
  final String message;
  WarningMyWalletState({required this.message});
  @override
  List<Object?> get props => [message];
}

class ImageMyWalletState extends ReservationStates {
  final String message;
  ImageMyWalletState({required this.message});
  @override
  List<Object?> get props => [message];
}

class ImageWithGiftMyWalletState extends ReservationStates {
  final String message;
  ImageWithGiftMyWalletState({required this.message});
  @override
  List<Object?> get props => [message];
}

class LoadingElectronicWalletState extends ReservationStates {
  List<Object?> get props => [];
}

class LoadedElectronicWalletState extends ReservationStates {
  ReservationResponseElectronicModel reservationResponseElectronicModel;
  LoadedElectronicWalletState(
      {required this.reservationResponseElectronicModel});
  List<Object?> get props => [];
}

class ErrorElectronicWalletState extends ReservationStates {
  String error;
  ErrorElectronicWalletState({required this.error});
  List<Object?> get props => [];
}

// New states for ElectronicWallet
class ConfirmationElectronicWalletState extends ReservationStates {
  final String message;
  ConfirmationElectronicWalletState({required this.message});
  @override
  List<Object?> get props => [message];
}

class WarningElectronicWalletState extends ReservationStates {
  final String message;
  WarningElectronicWalletState({required this.message});
  @override
  List<Object?> get props => [message];
}

class ImageElectronicWalletState extends ReservationStates {
  final String message;
  ImageElectronicWalletState({required this.message});
  @override
  List<Object?> get props => [message];
}

class ImageWithGiftElectronicWalletState extends ReservationStates {
  final String message;
  ImageWithGiftElectronicWalletState({required this.message});
  @override
  List<Object?> get props => [message];
}

class LoadingCreditCardState extends ReservationStates {
  List<Object?> get props => [];
}

class LoadedCreditCardState extends ReservationStates {
  ReservationResponseCreditCard reservationResponseCreditCard;
  LoadedCreditCardState({required this.reservationResponseCreditCard});
  List<Object?> get props => [];
}

class ErrorCreditCardState extends ReservationStates {
  String error;
  ErrorCreditCardState({required this.error});
  List<Object?> get props => [];
}

// New states for CreditCard
class ConfirmationCreditCardState extends ReservationStates {
  final String message;
  ConfirmationCreditCardState({required this.message});
  @override
  List<Object?> get props => [message];
}

class WarningCreditCardState extends ReservationStates {
  final String message;
  WarningCreditCardState({required this.message});
  @override
  List<Object?> get props => [message];
}

class ImageCreditCardState extends ReservationStates {
  final String message;
  ImageCreditCardState({required this.message});
  @override
  List<Object?> get props => [message];
}

class ImageWithGiftCreditCardState extends ReservationStates {
  final String message;
  ImageWithGiftCreditCardState({required this.message});
  @override
  List<Object?> get props => [message];
}
