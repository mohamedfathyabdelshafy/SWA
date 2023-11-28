import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';
import 'package:swa/features/forgot_password/presentation/cubit/forgot_password_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox( height: context.height * 0.15),
              SvgPicture.asset("assets/images/Swa Logo.svg"),
              SizedBox( height: context.height * 0.09),
              Text(
                "Forgot Password",
                style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                "Please enter your retested email to send the custom Regain code via email",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20,),
              CustomizedField(
                colorText: Colors.white,
                color :AppColors.lightBink,hintText: "Enter Email",
                controller: emailController,
                validator: (validator){
                  if(validator == null || validator.isEmpty) {
                    return "Enter Email";
                  }
                  String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(validator)) {
                    return "Your Email is invalid";
                  } else {
                    return null;
                  }
                },
              ),
              BlocListener(
                bloc: BlocProvider.of<ForgotPasswordCubit>(context),
                listener: (context, state) {
                  if(state is ForgotPasswordLoadingState){
                    Constants.showLoadingDialog(context);
                  }else if (state is ForgotPasswordLoadedState) {
                    Constants.hideLoadingDialog(context);
                    if(state.messageResponse.status == 'failed') {
                      Constants.showDefaultSnackBar(context: context, text: state.messageResponse.massage.toString());
                    }else {
                      Navigator.pushNamed(context, Routes.createPasscode);
                    }
                  }else if (state is ForgotPasswordErrorState) {
                    Constants.hideLoadingDialog(context);
                    Constants.showDefaultSnackBar(context: context, text: state.error.toString());
                  }
                },
                child: InkWell(
                    onTap: (){
                      if(formKey.currentState!.validate()) {
                        BlocProvider.of<ForgotPasswordCubit>(context).forgotPassword(ForgotPasswordParams(email: emailController.text));
                      }
                    },
                    child: Constants.customButton(text: "Send Code")
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
