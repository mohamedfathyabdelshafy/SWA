part of 'forgot_password_cubit.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}
//ForgotPassword States
class ForgotPasswordLoadedState extends ForgotPasswordState {
  final MessageResponse messageResponse;
  ForgotPasswordLoadedState({required this.messageResponse});
  List<Object> get props => [messageResponse];
}
//Error States
class ForgotPasswordErrorState extends ForgotPasswordState {
  final Object error;
  ForgotPasswordErrorState({required this.error});
  Object get props => error;
}