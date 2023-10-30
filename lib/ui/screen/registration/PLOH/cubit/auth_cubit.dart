import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/data/model/UserResponse.dart';
import 'package:swa/data/repo/auth_repo/auth_repo.dart';
import 'package:swa/ui/screen/registration/PLOH/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit():super(AuthInitialState());

UserResponse userResponse = UserResponse();
   login (String email,String password)async{
    emit(AuthLoadingState());
    await ApiManager.login(email, password).then((value){
      if(value.status == "failed"){
        emit(AuthErrorState(message: "invalid userName or password"));
        log("${userResponse.status!}", name: "response");
      }else {
        emit(AuthSuccessState());
        userResponse = value;
      }
    }).catchError((error){
      emit(AuthErrorState(message: error.toString()));
    });
      emit(AuthInitialState());
    }
  }