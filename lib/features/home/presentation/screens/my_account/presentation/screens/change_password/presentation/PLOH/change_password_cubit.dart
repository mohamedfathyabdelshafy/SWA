import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/data/model/change_password_response.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/data/repo/change_password_repo.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/PLOH/change_password_states.dart';
import 'package:swa/main.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates>{
  ChangePasswordCubit():super(ChangePasswordInitial());
  ChangePasswordRepo changePasswordRepo = ChangePasswordRepo(sl());

  Future<ChangePasswordResponse?> changePassword(
      {
        required String userId,
        required String oldPass,
        required String newPass
      }
      )async{
    try {
      emit(ChangePasswordInitial());
      final res = await changePasswordRepo.changePassword(
          userId: userId, oldPass: oldPass, newPass: newPass);
      if(res != null){
        emit(ChangePasswordLoaded(changePasswordResponse: res));
      }
      else{
        emit(ChangePasswordError(msg: res!.message!));
      }
    }catch(e){
      print(e.toString());
    }
  }

}