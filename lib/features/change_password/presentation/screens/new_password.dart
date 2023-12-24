import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/change_password/domain/use_cases/new_password.dart';
import 'package:swa/features/change_password/presentation/cubit/new_password_cubit.dart';
import 'package:swa/features/sign_in/data/models/user_model.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';


class NewPasswordScreen extends StatefulWidget {
   NewPasswordScreen({Key? key,required this.userId}) : super(key: key);
String userId;
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController REnewPassController = TextEditingController();
  final TextEditingController passController = TextEditingController();

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

          child: Directionality(
            textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height:context.height * 0.15),
                    SvgPicture.asset("assets/images/Swa Logo.svg"),
                    SizedBox(height:context.height * 0.15),
                    SizedBox(
                      height: context.height*0.30,
                      child: Column(
                        children: [
                          CustomizedField(
                            isPassword: false,
                            obscureText: false,
                            colorText: AppColors.greyLight,
                            controller:passController ,
                            validator: (validator){
                              if (validator == null || validator.isEmpty) {
                                return LanguageClass.isEnglish ? " Enter the code" : "ادخل الكود";
                              }
                              return null;
                            },
                            color:Colors.white.withOpacity(0.2),
                            labelText: LanguageClass.isEnglish?"Code":"الكود",
                          ),
                          CustomizedField(
                              colorText: Colors.white,
                              isPassword: true,
                              obscureText: true,
                              color :AppColors.lightBink,
                              hintText: LanguageClass.isEnglish?"Enter new password":
                              "ادخل كلمة المرور الجديدة",
                              controller: newPassController,
                              validator: (value){
                                if(value == null ||value.isEmpty ){
                                  return  LanguageClass.isEnglish?"Enter new password":
                                  " ادخال كلمة المرور";
                                }
                                return null;
                              }
                          ),
                          CustomizedField(
                              colorText: Colors.white,
                              isPassword: true,
                              obscureText: true,
                              color :AppColors.lightBink,
                              hintText: LanguageClass.isEnglish?"ReEnter new password":
                              "اعادة ادخال كلمة المرور",
                              controller: REnewPassController,
                              validator: (value){
                                if(value == null ||value.isEmpty ){
                                  return  LanguageClass.isEnglish?"ReEnter new password":
                                  "اعادة ادخال كلمة المرور الجديدة";
                                }
                                return null;
                              }
                          ),
                        ],
                      ),
                    ),
                    BlocListener(
                      bloc: BlocProvider.of<NewPasswordCubit>(context),
                      listener: (context, state) {
                        if(state is NewPasswordLoadingState){
                          Constants.showLoadingDialog(context);
                        }else if (state is NewPasswordLoadedState) {
                          Constants.hideLoadingDialog(context);
                          Navigator.pushNamed(context, Routes.doneLoginRoute);
                        }else if (state is NewPasswordErrorState) {
                          Constants.hideLoadingDialog(context);
                          Constants.showDefaultSnackBar(context: context, text: state.error.toString());
                        }
                      },
                      child: InkWell(
                          onTap: (){
                            if(formKey.currentState!.validate()) {
                              ///Change old password to code
                              BlocProvider.of<NewPasswordCubit>(context).newPassword(
                                NewPasswordParams(oldPass: passController.text, newPass: newPassController.text, userId: widget.userId)
                              );
                            }
                          },
                          child: Constants.customButton(text: LanguageClass.isEnglish?"Done":"تم")
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

