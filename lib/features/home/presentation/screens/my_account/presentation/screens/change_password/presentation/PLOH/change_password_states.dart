import 'package:equatable/equatable.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/data/model/change_password_response.dart';

abstract class ChangePasswordStates extends Equatable{

}
class ChangePasswordInitial extends ChangePasswordStates {
  @override
  List<Object?> get props => [];
}


class ChangePasswordLoading extends ChangePasswordStates {
  @override

List<Object?> get props => [];
}


class ChangePasswordLoaded extends ChangePasswordStates {
  ChangePasswordResponse changePasswordResponse;
  ChangePasswordLoaded({required this.changePasswordResponse});
  @override
List<Object?> get props => [];
}
class ChangePasswordError extends ChangePasswordStates {

  String msg;
  ChangePasswordError({required this.msg});
  @override
List<Object?> get props => [];
}