part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}
//Login States
class UserLoginLoadedState extends LoginState {
  final UserResponse userResponse;
  UserLoginLoadedState({required this.userResponse});
  List<Object> get props => [userResponse];
}
//Error States
class LoginErrorState extends LoginState {
  final Object error;
  LoginErrorState({required this.error});
  Object get props => error;
}