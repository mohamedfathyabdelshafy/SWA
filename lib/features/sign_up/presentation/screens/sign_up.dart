import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/app_info/domain/entities/city.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_country_cities_cubit/get_available_country_cities_cubit.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';
import 'package:swa/features/sign_up/presentation/cubit/register_cubit.dart';
import 'package:swa/features/sign_up/presentation/screens/component/city_drop_down_button.dart';
import 'package:swa/features/sign_up/presentation/screens/component/country_drop_down_button.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController rePasswordController = TextEditingController();

  final TextEditingController citycontroller = TextEditingController();

  final TextEditingController countrycontroller = TextEditingController();

  Country? _selectedCountry;
  City? _selectedCity;

  @override
  void initState() {
    emailController.text = Routes.emailaddress;
    super.initState();
    BlocProvider.of<GetAvailableCountriesCubit>(context)
        .getAvailableCountries();
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
                      color: AppColors.primaryColor,
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
                          style: TextStyle(
                              fontFamily: 'bold',
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
                                ? 'Full Name'
                                : 'الاسم كامل',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'regular',
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
                          hintText: '',
                          controller: nameController,
                          validator: (validator) {
                            if (validator == null || validator.isEmpty) {
                              return LanguageClass.isEnglish
                                  ? "Enter name"
                                  : "ادخل الاسم";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                          child: Text(
                            LanguageClass.isEnglish
                                ? 'Mobile Number'
                                : 'رقم التليفون',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'regular',
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
                          hintText: "",
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          validator: (validator) {
                            if (validator == null || validator.isEmpty) {
                              return LanguageClass.isEnglish
                                  ? "Enter phone"
                                  : "ادخل الموبيل";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                          child: Text(
                            LanguageClass.isEnglish
                                ? 'Email'
                                : 'البريد الالكتروني',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'regular',
                                color: Color(0xff616b80),
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                        CustomizedField(
                          colorText: Colors.black,
                          borderradias: 33,
                          isPassword: false,
                          obscureText: false,
                          readonly: true,
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

                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                          child: Text(
                            LanguageClass.isEnglish
                                ? "Select your country"
                                : "ادخل الدولة",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'regular',
                                color: Color(0xff616b80),
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                        BlocBuilder<GetAvailableCountriesCubit,
                                GetAvailableCountriesCubitState>(
                            builder: (context, state) {
                          return state is GetAvailableCountriesLoadedState
                              ? CountryDropDownTextFieldButton(
                                  countries: state.countries,
                                  controller: countrycontroller,
                                  hintText:
                                      _selectedCountry?.countryName != null
                                          ? _selectedCountry!.countryName
                                          : LanguageClass.isEnglish
                                              ? "Select your country"
                                              : "ادخل الدولة",
                                  onSelect: (country) {
                                    setState(() {
                                      _selectedCountry = country;
                                      _selectedCity = null;
                                    });
                                    BlocProvider.of<
                                                GetAvailableCountryCitiesCubit>(
                                            context)
                                        .getAvailableCountries(
                                            _selectedCountry!.countryId);
                                  },
                                )
                              : const SizedBox(height: 0.0, width: 0.0);
                        }),
                        BlocBuilder<GetAvailableCountryCitiesCubit,
                                GetAvailableCountryCitiesCubitState>(
                            builder: (context, state) {
                          return state is GetAvailableCountryCitiesLoadedState
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 30),
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? "Select your city"
                                            : "ادخل المدينة",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'regular',
                                            color: Color(0xff616b80),
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    CityDropDownTextFieldButton(
                                      countries: state.countryCities,
                                      controller: citycontroller,
                                      hintText: _selectedCity?.cityName != null
                                          ? _selectedCity!.cityName
                                          : LanguageClass.isEnglish
                                              ? "Enter your city"
                                              : "ادخل المدينة",
                                      onSelect: (city) {
                                        setState(() {
                                          _selectedCity = city;
                                        });

                                        log(_selectedCity!.cityId.toString());
                                      },
                                    ),
                                  ],
                                )
                              : const SizedBox(height: 0.0, width: 0.0);
                        }),

                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                          child: Text(
                            LanguageClass.isEnglish
                                ? "Enter Your Password(min 8 characters)"
                                : "ادخل كلمة المرور لا تقل عن 8 احرف",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'regular',
                                color: Color(0xff616b80),
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                        CustomizedField(
                          colorText: Colors.black,
                          borderradias: 33,
                          isPassword: true,
                          obscureText: true,
                          color: Color(0xffDDDDDD),
                          controller: passwordController,
                          validator: (validator) {
                            if (validator == null || validator.isEmpty) {
                              return LanguageClass.isEnglish
                                  ? " your password"
                                  : " ادخال كلمة المرور";
                            }
                            return null;
                          },
                          hintText: '',
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                          child: Text(
                            LanguageClass.isEnglish
                                ? "Confirm Your Password"
                                : "موافقة كلمة المرور",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'regular',
                                color: Color(0xff616b80),
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                        CustomizedField(
                          colorText: Colors.black,
                          borderradias: 33,
                          isPassword: true,
                          obscureText: true,
                          color: Color(0xffDDDDDD),
                          controller: rePasswordController,
                          validator: (validator) {
                            if (validator == null || validator.isEmpty) {
                              return LanguageClass.isEnglish
                                  ? "Confirm your password"
                                  : "اعادة ادخال كلمة المرور";
                            }
                            return null;
                          },
                          hintText: '',
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        BlocListener(
                          bloc: BlocProvider.of<RegisterCubit>(context),
                          listener: (context, state) {
                            if (state is RegisterLoadingState) {
                              Constants.showLoadingDialog(context);
                            } else if (state is UserRegisterLoadedState) {
                              Constants.hideLoadingDialog(context);
                              Constants.showDefaultSnackBar(
                                  context: context,
                                  text:
                                      state.messageResponse.massage.toString(),
                                  color: Colors.green);

                              Navigator.pushReplacementNamed(
                                  context, Routes.signInRoute);
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
                                if (_selectedCountry == null) {
                                  Constants.hideLoadingDialog(context);
                                  Constants.showDefaultSnackBar(
                                      context: context,
                                      text: "Select your country..");
                                  return;
                                }
                                if (_selectedCity == null) {
                                  Constants.hideLoadingDialog(context);
                                  Constants.showDefaultSnackBar(
                                      context: context,
                                      text: "Select your city..");
                                  return;
                                }
                                BlocProvider.of<RegisterCubit>(context)
                                    .registerUser(UserRegisterParams(
                                  name: nameController.text,
                                  mobile: mobileController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  userType: "Customer",
                                  countryId: _selectedCountry!.countryId,
                                  cityId: _selectedCity!.cityId,
                                ));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(41)),
                              child: Center(
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? "Sign Up"
                                      : "انشاء الحساب",
                                  style: TextStyle(
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
