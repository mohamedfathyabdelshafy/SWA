abstract class AuthStates {}
class AuthInitialState extends AuthStates{}
class AuthSuccessState extends AuthStates{}
class AuthErrorState extends AuthStates{
  String message;
  AuthErrorState({required this.message});
}
class AuthLoadingState extends AuthStates{}