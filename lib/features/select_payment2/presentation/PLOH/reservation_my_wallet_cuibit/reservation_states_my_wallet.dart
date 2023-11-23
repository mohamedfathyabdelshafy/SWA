import 'package:equatable/equatable.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Reservation_Response_fawry_model.dart';
import 'package:swa/features/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/features/select_payment2/data/models/Reservation_Response_Electronic_model.dart';
import 'package:swa/features/select_payment2/data/models/Reservation_response_MyWallet_model.dart';


abstract class ReservationStates extends Equatable {
}
class LoadingMyWalletState extends ReservationStates{
  List<Object?> get props =>[];
}
class InitialReservationStates extends ReservationStates{
  @override
  List<Object?> get props => [];

}
class LoadedMyWalletState extends ReservationStates{
  ReservationResponseMyWalletModel reservationResponseMyWalletModel;
  LoadedMyWalletState({required this.reservationResponseMyWalletModel});
  List<Object?> get props =>[];
}
class ErrorMyWalletState extends ReservationStates{
 String error;
 ErrorMyWalletState({required this.error});
  List<Object?> get props =>[];
}

class LoadingElectronicWalletState extends ReservationStates{
  List<Object?> get props =>[];
}

class LoadedElectronicWalletState extends ReservationStates{
  ReservationResponseElectronicModel reservationResponseElectronicModel;
  LoadedElectronicWalletState({required this.reservationResponseElectronicModel});
  List<Object?> get props =>[];
}
class ErrorElectronicWalletState extends ReservationStates{
  String error;
  ErrorElectronicWalletState({required this.error});
  List<Object?> get props =>[];
}
class LoadingCreditCardState extends ReservationStates{
  List<Object?> get props =>[];
}

class LoadedCreditCardState extends ReservationStates{
  ReservationResponseCreditCard reservationResponseCreditCard;
  LoadedCreditCardState({required this.reservationResponseCreditCard});
  List<Object?> get props =>[];
}
class ErrorCreditCardState extends ReservationStates{
  String error;
  ErrorCreditCardState({required this.error});
  List<Object?> get props =>[];
}