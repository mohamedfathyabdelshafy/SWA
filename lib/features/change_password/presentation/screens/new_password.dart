import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/change_password/domain/use_cases/new_password.dart';
import 'package:swa/features/change_password/presentation/cubit/new_password_cubit.dart';
import 'package:swa/features/sign_in/data/models/user_model.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';


class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newPassController = TextEditingController();
  User? _user;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
    });
    super.initState();
  }


  @override
  void dispose() {
    newPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: BlocListener(

          bloc: BlocProvider.of<LoginCubit>(context),
          listener: (context, state) {
            if (state is UserLoginLoadedState) {
              _user = state.userResponse.user;
            }
          },

          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height:context.height * 0.15),
                SvgPicture.asset("assets/images/Swa Logo.svg"),
                SizedBox(height:context.height * 0.15),
                SizedBox(
                  height: context.height*0.22,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomizedField(
                            colorText: Colors.white,
                            isPassword: true,
                            obscureText: true,
                            color :AppColors.lightBink,
                            hintText: "Enter new password",
                            controller: newPassController,
                            validator: (value){
                              if(value == null ||value.isEmpty ){
                                return  "Enter new password";
                              }
                              return null;
                            }
                        ),
                        CustomizedField(
                            colorText: Colors.white,
                            isPassword: true,
                            obscureText: true,
                            color :AppColors.lightBink,
                            hintText: "ReEnter new password",
                            controller: newPassController,
                            validator: (value){
                              if(value == null ||value.isEmpty ){
                                return  "ReEnter new password";
                              }
                              return null;
                            }
                        ),
                      ],
                    ),
                  ),
                ),
                BlocListener(
                  bloc: BlocProvider.of<NewPasswordCubit>(context),
                  listener: (context, state) {
                    if(state is NewPasswordLoadingState){
                      Constants.showLoadingDialog(context);
                    }else if (state is NewPasswordLoadedState) {
                      Constants.hideLoadingDialog(context);
                      // Navigator.pushNamed(context, Routes.doneLoginRoute);
                    }else if (state is NewPasswordErrorState) {
                      Constants.hideLoadingDialog(context);
                      Constants.showDefaultSnackBar(context: context, text: state.error.toString());
                    }
                  },
                  child: InkWell(
                      onTap: (){
                        if(formKey.currentState!.validate()) {
                          ///Change old password to code
                          // BlocProvider.of<NewPasswordCubit>(context).newPassword(
                          //   NewPasswordParams(oldPass: oldPassController.text, newPass: newPassController.text, userId: _user!.userId!.toString())
                          // );
                        }
                      },
                      child: Constants.customButton(text: "Done")
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

