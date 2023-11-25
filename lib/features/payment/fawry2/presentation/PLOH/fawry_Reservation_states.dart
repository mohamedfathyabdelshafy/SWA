import '../../../select_payment/domain/entities/payment_message_response.dart';

abstract class FawryReservationState {}

class FawryReservationInitial extends FawryReservationState {}

class FawryLoadingReservationState extends FawryReservationState {}
//Fawry States
class FawryLoadedReservationState extends FawryReservationState {
  final PaymentMessageResponse paymentMessageResponse;
  FawryLoadedReservationState({required this.paymentMessageResponse});
  List<Object> get props => [paymentMessageResponse];
}
//Error States
class FawryErrorReservationState extends FawryReservationState {
  final String error;

  FawryErrorReservationState({required this.error});

  Object get props => error;
}