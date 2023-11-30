import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/PLOH/change_password_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/PLOH/change_password_states.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';

class ChangePassword extends StatelessWidget {
   ChangePassword({super.key,required this.user});
   User user;
TextEditingController oldPassController =TextEditingController();
   TextEditingController newPassController =TextEditingController();
   TextEditingController confirmPassController =TextEditingController();
 final GlobalKey<FormState> formKey = GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
            size: 34,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: BlocListener<ChangePasswordCubit,ChangePasswordStates>(
        bloc: BlocProvider.of<ChangePasswordCubit>(context),
        listener: (context,state){
          if(state is ChangePasswordLoading){
            Constants.showLoadingDialog(context);
          }if(state is ChangePasswordLoaded){
            Constants.hideLoadingDialog(context);
            Constants.showDefaultSnackBar(context: context, text: state.changePasswordResponse.message!);
          }if(state is ChangePasswordError){
            Constants.hideLoadingDialog(context);
            Constants.showDefaultSnackBar(context: context, text: state.msg);
          }
        },
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Change Password" ,
                  style: TextStyle(color: AppColors.white,fontSize: 34,fontFamily: "bold"),
                ),
                SizedBox(height: 15,),
                CustomizedField(
                  isPassword: false,
                  obscureText: false,
                  colorText: AppColors.greyLight,
                  controller:oldPassController ,
                  validator: (validator){
                    if(validator == null || validator.isEmpty) {
                      return "Enter your old password";
                    }
                    return null;
                  },
                  color:Colors.white.withOpacity(0.2),
                  labelText: "Old Password",
                ),
                SizedBox(height: 15,),
                CustomizedField(
                  isPassword: false,
                  obscureText: false,
                  colorText: AppColors.greyLight,
                  controller:newPassController ,
                  validator: (validator){
                    if(validator == null || validator.isEmpty) {
                      return "Enter your new Password";
                    }
                    return null;
                  },
                  color:Colors.white.withOpacity(0.2),
                  labelText: "New Password",
                ),
                SizedBox(height: 15,),
                CustomizedField(
                  isPassword: false,
                  obscureText: false,
                  colorText: AppColors.greyLight,
                  controller:confirmPassController ,
                  validator: (validator){
                    if(validator == null || validator.isEmpty) {
                      return "Confirm your password";
                    }
                    return null;
                  },
                  color:Colors.white.withOpacity(0.2),
                  labelText: "Confirm New Password",
                ),
                Spacer(),
                InkWell(
                  onTap: (){
                    if(!formKey.currentState!.validate())return;
                    BlocProvider.of<ChangePasswordCubit>(context).changePassword(
                        userId: user.userId!,
                        oldPass: oldPassController.text,
                        newPass: confirmPassController.text);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Constants.customButton(text: "Save",color: AppColors.primaryColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
