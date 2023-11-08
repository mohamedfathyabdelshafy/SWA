part of 'new_password_cubit.dart';

abstract class NewPasswordState {}

class NewPasswordInitial extends NewPasswordState {}

class NewPasswordLoadingState extends NewPasswordState {}
//NewPassword States
class NewPasswordLoadedState extends NewPasswordState {
  final MessageResponse messageResponse;
  NewPasswordLoadedState({required this.messageResponse});
  List<Object> get props => [messageResponse];
}
//Error States
class NewPasswordErrorState extends NewPasswordState {
  final Object error;
  NewPasswordErrorState({required this.error});
  Object get props => error;
}