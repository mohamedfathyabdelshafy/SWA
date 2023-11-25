part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterState {}
//Register States
class UserRegisterLoadedState extends RegisterState {
  final MessageResponse messageResponse;
  UserRegisterLoadedState({required this.messageResponse});
  List<Object> get props => [messageResponse];
}
//Error States
class RegisterErrorState extends RegisterState {
  final Object error;
  RegisterErrorState({required this.error});
  Object get props => error;
}