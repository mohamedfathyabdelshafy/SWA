import 'package:equatable/equatable.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/data/model/personal_info_edit_response.dart';

abstract class PersonalInfoStates extends Equatable{

}
class PersonalInfoInitial extends PersonalInfoStates {
  @override
  List<Object?> get props => [];
}


class PersonalInfoLoading extends PersonalInfoStates {
  @override

  List<Object?> get props => [];
}


class PersonalInfoLoaded extends PersonalInfoStates {
  PersonalInfoEditResponse personalInfoResponse;
  PersonalInfoLoaded({required this.personalInfoResponse});
  @override
  List<Object?> get props => [];
}
class PersonalInfoError extends PersonalInfoStates {

  String msg;
  PersonalInfoError({required this.msg});
  @override
  List<Object?> get props => [];
}