part of 'fawry_cubit.dart';

abstract class FawryState {}

class FawryInitial extends FawryState {}

class FawryLoadingState extends FawryState {}
//Fawry States
class FawryLoadedState extends FawryState {
  final PaymentMessageResponse paymentMessageResponse;
  FawryLoadedState({required this.paymentMessageResponse});
  List<Object> get props => [paymentMessageResponse];
}
//Error States
class FawryErrorState extends FawryState {
  final Object error;
  FawryErrorState({required this.error});
  Object get props => error;
}