part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

//Register States
class UserRegisterLoadedState extends RegisterState {
  final MessageResponse messageResponse;
  UserRegisterLoadedState({required this.messageResponse});
}

//Error States
class RegisterErrorState extends RegisterState {
  final String error;
  RegisterErrorState({required this.error});
}

class EmailsendState extends RegisterState {
  final String message;
  EmailsendState({required this.message});
}

class DocumenttypeState extends RegisterState {
  final IdentificationTypeModel documentTypeModel;
  DocumenttypeState({required this.documentTypeModel});
}

class TextfiedidState extends RegisterState {
  final Idtextfieldmodel idtextfieldmodel;
  TextfiedidState({required this.idtextfieldmodel});
}

class phonecodeState extends RegisterState {
  final PhonecountrycodeModel phonecountrycodeModel;
  phonecodeState({required this.phonecountrycodeModel});
}
