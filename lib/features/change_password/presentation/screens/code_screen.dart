import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/change_password/domain/use_cases/new_password.dart';
import 'package:swa/features/change_password/presentation/cubit/new_password_cubit.dart';
import 'package:swa/features/change_password/presentation/screens/new_password.dart';
import 'package:swa/features/sign_in/data/models/user_model.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/main.dart';

class CodeScreen extends StatefulWidget {
  CodeScreen({Key? key, required this.userId}) : super(key: key);
  String userId;
  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeWidth / 10),
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
                child: SizedBox(
                  height: sizeHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: context.height * 0.05),
                      Container(
                        alignment: LanguageClass.isEnglish
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.primaryColor,
                            size: 35,
                          ),
                        ),
                      ),
                      SizedBox(height: context.height * 0.08),
                      Image.asset("assets/images/applogo.png"),
                      SizedBox(height: context.height * 0.1),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LanguageClass.isEnglish
                                  ? "Enter Code"
                                  : "ادخل الكود",
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'bold',
                                  fontSize: 24),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: const TextStyle(
                                  color: Color(0xffDDDDDD),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'pop'),
                              length: 4,
                              obscureText: false,
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: 'pop'),

                              blinkWhenObscuring: true,
                              backgroundColor: Colors.transparent,

                              animationType: AnimationType.fade,
                              autoUnfocus: true,
                              autoFocus: true,
                              validator: (validator) {
                                if (validator == null || validator.isEmpty) {
                                  return LanguageClass.isEnglish
                                      ? " Enter the code"
                                      : "ادخل الكود";
                                }
                                return null;
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                disabledColor: Color(0xffDDDDDD),
                                activeColor: const Color(0xffDDDDDD),
                                selectedColor: const Color(0xffDDDDDD),
                                inactiveColor: const Color(0xffDDDDDD),
                                inactiveFillColor: Color(0xffDDDDDD),
                                selectedFillColor: Color(0xffDDDDDD),
                                fieldOuterPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                borderWidth: 1,
                                borderRadius: BorderRadius.circular(100),
                                fieldHeight: 60,
                                fieldWidth: 60,
                                activeFillColor: Color(0xffDDDDDD),
                              ),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              controller: codeController,
                              keyboardType: TextInputType.number,
                              mainAxisAlignment: MainAxisAlignment.center,

                              onCompleted: (v) async {
                                debugPrint("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {},
                              enablePinAutofill: false,
                              errorTextMargin: const EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      BlocListener(
                        bloc: BlocProvider.of<NewPasswordCubit>(context),
                        listener: (context, state) {
                          if (state is NewPasswordLoadingState) {
                            Constants.showLoadingDialog(context);
                          } else if (state is NewPasswordLoadedState) {
                            Constants.hideLoadingDialog(context);
                            Navigator.pushNamed(context, Routes.doneLoginRoute);
                          } else if (state is NewPasswordErrorState) {
                            Constants.hideLoadingDialog(context);
                            Constants.showDefaultSnackBar(
                                context: context, text: state.error.toString());
                          }
                        },
                        child: InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<LoginCubit>(
                                                    create: (context) =>
                                                        sl<LoginCubit>(),
                                                  ),
                                                  BlocProvider<
                                                      NewPasswordCubit>(
                                                    create: (context) =>
                                                        sl<NewPasswordCubit>(),
                                                  ),
                                                ],
                                                child: NewPasswordScreen(
                                                  userId: widget.userId,
                                                  code: codeController.text,
                                                ))));
                              }
                            },
                            child: Constants.customButton(
                                borderradias: 41,
                                color: AppColors.primaryColor,
                                text: LanguageClass.isEnglish
                                    ? "Create New Password"
                                    : " إنشاء كلمة مرور جديدة")),
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
