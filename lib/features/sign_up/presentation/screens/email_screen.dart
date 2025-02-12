import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/app_info/domain/entities/city.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_country_cities_cubit/get_available_country_cities_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/send_message_model.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';
import 'package:swa/features/sign_up/presentation/cubit/register_cubit.dart';
import 'package:swa/features/sign_up/presentation/screens/component/city_drop_down_button.dart';
import 'package:swa/features/sign_up/presentation/screens/component/country_drop_down_button.dart';
import 'package:swa/features/sign_up/presentation/screens/verifed_code.dart';

class Emailscreen extends StatefulWidget {
  Emailscreen({Key? key}) : super(key: key);

  @override
  State<Emailscreen> createState() => _EmailscreenState();
}

class _EmailscreenState extends State<Emailscreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.height * 0.05),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 27),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Routes.isomra
                          ? AppColors.umragold
                          : AppColors.primaryColor,
                      size: 35,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeWidth / 10),
                  child: Container(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        SizedBox(height: context.height * 0.01),
                        Text(
                          LanguageClass.isEnglish ? "Sign Up" : "انشاء حساب",
                          textAlign: TextAlign.start,
                          style: fontStyle(
                              fontFamily: FontFamily.bold,
                              color: HexColor('#000000'),
                              fontSize: 34),
                        ),
                        // SizedBox(height:context.height *0.03 ,),
                        SizedBox(
                          height: 48,
                        ),

                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                          child: Text(
                            LanguageClass.isEnglish
                                ? 'Email'
                                : 'البريد الالكتروني',
                            style: fontStyle(
                                fontSize: 16,
                                fontFamily: FontFamily.regular,
                                color: Color(0xff616b80),
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                        CustomizedField(
                          colorText: Colors.black,
                          borderradias: 33,
                          isPassword: false,
                          obscureText: false,
                          color: Color(0xffDDDDDD),
                          hintText: LanguageClass.isEnglish
                              ? "ex@email.com"
                              : "ex@email.com",
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (validator) {
                            if (validator == null || validator.isEmpty) {
                              return LanguageClass.isEnglish
                                  ? "Enter Email"
                                  : "ادخل الايميل";
                            }
                            String pattern =
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(validator)) {
                              return LanguageClass.isEnglish
                                  ? "Your Email is invalid"
                                  : "هذا الايميل غير صالح";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        BlocListener(
                          bloc: BlocProvider.of<RegisterCubit>(context),
                          listener: (context, state) {
                            if (state is RegisterLoadingState) {
                              Constants.showLoadingDialog(context);
                            } else if (state is EmailsendState) {
                              if (state.message == 'success') {
                                Routes.emailaddress = emailController.text;

                                Navigator.pushReplacementNamed(
                                    context, Routes.verifyemailroure);
                              }
                            } else if (state is RegisterErrorState) {
                              Constants.hideLoadingDialog(context);
                              Constants.showDefaultSnackBar(
                                  context: context,
                                  text: state.error.toString());
                            }
                          },
                          child: InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<RegisterCubit>(context)
                                    .Sendcodeemail(email: emailController.text);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                              decoration: BoxDecoration(
                                  color: Routes.isomra
                                      ? AppColors.umragold
                                      : AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(41)),
                              child: Center(
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? "Sign Up"
                                      : "انشاء الحساب",
                                  style: fontStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
