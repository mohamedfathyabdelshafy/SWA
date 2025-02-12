import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
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
import 'package:swa/features/bus_reservation_layout/data/models/id_textfield_model.dart';
import 'package:swa/features/bus_reservation_layout/data/models/phoneCode_model.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';
import 'package:swa/features/sign_up/presentation/cubit/register_cubit.dart';
import 'package:swa/features/sign_up/presentation/screens/component/city_drop_down_button.dart';
import 'package:swa/features/sign_up/presentation/screens/component/country_drop_down_button.dart';

import '../../../bus_reservation_layout/data/models/documentType_model.dart';

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

  final TextEditingController idcontroller = TextEditingController();

  Country? _selectedCountry;

  String selectedcode = '+20';
  PhonecountrycodeModel phonecountrycodeModel =
      PhonecountrycodeModel(codelist: []);
  City? _selectedCity;
  IdentificationTypeModel? docType;
  List<documentdetails> documentDaata = [];

  String indentificationtypeID = '';

  Idtextfieldmodel? idtextfieldmodel = Idtextfieldmodel(
      message: Message(title: '', length: 0, validationMesage: ''));

  @override
  void initState() {
    emailController.text = Routes.emailaddress;
    super.initState();
    BlocProvider.of<GetAvailableCountriesCubit>(context)
        .getAvailableCountries();

    BlocProvider.of<RegisterCubit>(context).GetIdentificationType();
    BlocProvider.of<RegisterCubit>(context).getphonecode();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return BlocListener<RegisterCubit, RegisterState>(
      bloc: BlocProvider.of<RegisterCubit>(context),
      listener: (context, state) {
        if (state is phonecodeState) {
          phonecountrycodeModel = state.phonecountrycodeModel;
        } else if (state is TextfiedidState) {
          idtextfieldmodel = state.idtextfieldmodel;
        } else if (state is DocumenttypeState) {
          docType = state.documentTypeModel;
          documentDaata = state.documentTypeModel.message!.entries
              .map((entry) => documentdetails(entry.value, entry.key))
              .toList();
        } else if (state is RegisterLoadingState) {
          Constants.showLoadingDialog(context);
        } else if (state is UserRegisterLoadedState) {
          Constants.hideLoadingDialog(context);
          Constants.showDefaultSnackBar(
              context: context,
              text: state.messageResponse.massage.toString(),
              color: Colors.green);

          Navigator.pushReplacementNamed(context, Routes.signInRoute);
        } else if (state is RegisterErrorState) {
          Constants.hideLoadingDialog(context);
          Constants.showDefaultSnackBar(
              context: context, text: state.error.toString());
        }
      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        bloc: BlocProvider.of<RegisterCubit>(context),
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: Directionality(
              textDirection: LanguageClass.isEnglish
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.height * 0.08),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: sizeWidth / 10),
                        child: Container(
                          child: ListView(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              Text(
                                LanguageClass.isEnglish
                                    ? "Sign Up"
                                    : "انشاء حساب",
                                textAlign: TextAlign.start,
                                style: fontStyle(
                                    fontFamily: FontFamily.bold,
                                    color: HexColor('#000000'),
                                    fontSize: 34),
                              ),
                              // SizedBox(height:context.height *0.03 ,),
                              SizedBox(
                                height: 30,
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 30),
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? 'Full Name'
                                      : 'الاسم كامل',
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
                                height: 10,
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 30),
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? 'Mobile Number'
                                      : 'رقم التليفون',
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
                                prefixIcon: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isDismissible: true,
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        barrierColor:
                                            Colors.black.withOpacity(0.5),
                                        useRootNavigator: true,
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (buildContext,
                                                  StateSetter
                                                      setStater /*You can rename this!*/) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.7,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(24),
                                                              topRight: Radius
                                                                  .circular(
                                                                      24))),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.w),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 3),
                                                          height: 6,
                                                          width: 64.w,
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                      ),
                                                      24.verticalSpace,
                                                      Flexible(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              phonecountrycodeModel
                                                                  .codelist!
                                                                  .length,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          shrinkWrap: true,
                                                          physics:
                                                              ScrollPhysics(),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index2) {
                                                            return InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  selectedcode =
                                                                      phonecountrycodeModel
                                                                          .codelist![
                                                                              index2]
                                                                          .code!;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ))),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.symmetric(vertical: 5),
                                                                            child:
                                                                                FittedBox(fit: BoxFit.scaleDown, child: Text(phonecountrycodeModel.codelist![index2].name!, style: fontStyle(fontSize: 16, fontFamily: FontFamily.bold, fontWeight: FontWeight.w500, color: Colors.black))),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Text(phonecountrycodeModel.codelist![index2].code!, style: fontStyle(fontSize: 14, fontFamily: FontFamily.bold, fontWeight: FontWeight.w400, color: Colors.black54)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .arrow_forward_ios_rounded,
                                                                      color: AppColors
                                                                          .umragold,
                                                                      size: 15,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      16.verticalSpace,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                        });
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 70,
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Routes.isomra
                                            ? AppColors.umragold
                                            : AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      selectedcode,
                                      style: fontStyle(
                                          color: Colors.black,
                                          fontFamily: FontFamily.bold,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                ),
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
                                height: 10,
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 30),
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
                                height: 10,
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 30),
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? "Select your country"
                                      : "ادخل الدولة",
                                  style: fontStyle(
                                      fontSize: 16,
                                      fontFamily: FontFamily.regular,
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
                                            _selectedCountry?.countryName !=
                                                    null
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
                                          BlocProvider.of<RegisterCubit>(
                                                  context)
                                              .GetIdentificationType(
                                                  countryid: _selectedCountry!
                                                      .countryId
                                                      .toString());
                                        },
                                      )
                                    : const SizedBox(height: 0.0, width: 0.0);
                              }),
                              BlocBuilder<GetAvailableCountryCitiesCubit,
                                      GetAvailableCountryCitiesCubitState>(
                                  builder: (context, state) {
                                return state
                                        is GetAvailableCountryCitiesLoadedState
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              style: fontStyle(
                                                  fontSize: 16,
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  color: Color(0xff616b80),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          CityDropDownTextFieldButton(
                                            countries: state.countryCities,
                                            controller: citycontroller,
                                            hintText:
                                                _selectedCity?.cityName != null
                                                    ? _selectedCity!.cityName
                                                    : LanguageClass.isEnglish
                                                        ? "Enter your city"
                                                        : "ادخل المدينة",
                                            onSelect: (city) {
                                              setState(() {
                                                _selectedCity = city;
                                              });

                                              log(_selectedCity!.cityId
                                                  .toString());
                                            },
                                          ),
                                        ],
                                      )
                                    : const SizedBox(height: 0.0, width: 0.0);
                              }),

                              SizedBox(
                                height: 10,
                              ),

                              docType?.object?.display == true
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 30),
                                          child: Text(
                                            docType!.object!.title.toString(),
                                            style: fontStyle(
                                                fontSize: 16,
                                                fontFamily: FontFamily.regular,
                                                color: Color(0xff616b80),
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 0),
                                            child: DropDownTextField(
                                                initialValue: null,
                                                onChanged: (value) {
                                                  idcontroller.text = "";
                                                  if (value != null &&
                                                      value != "") {
                                                    indentificationtypeID =
                                                        value.value.toString();
                                                    BlocProvider.of<
                                                                RegisterCubit>(
                                                            context)
                                                        .getidtextfield(
                                                            countryid:
                                                                _selectedCountry
                                                                    ?.countryId
                                                                    .toString(),
                                                            iDTypeid: value
                                                                .value
                                                                .toString());
                                                  }
                                                },
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                textFieldDecoration:
                                                    InputDecoration(
                                                  fillColor: Color(0xffDDDDDD),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(33),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xffDDDDDD),
                                                              width: 0)),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(33),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              33),
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 0)),
                                                  filled: true,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 15,
                                                          vertical: 25),
                                                  suffixIcon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Color(0xff898989),
                                                  ),
                                                  hintText:
                                                      '${LanguageClass.isEnglish ? "Select document type" : "اختر نوع الوثيقة"}',
                                                  errorStyle: fontStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                          FontFamily.regular,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red),
                                                  hintStyle: fontStyle(
                                                    color: Color(0xffA2A2A2),
                                                    fontFamily:
                                                        FontFamily.medium,
                                                    height: 1.2,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                readOnly: true,
                                                validator: (value) {
                                                  if (docType?.object
                                                          ?.isRequired ==
                                                      true) {
                                                    if (value == null ||
                                                        value == "") {
                                                      return LanguageClass
                                                              .isEnglish
                                                          ? "Please select document type"
                                                          : "الرجاء اختيار نوع الوثيقة";
                                                    } else {
                                                      return null;
                                                    }
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                listTextStyle: fontStyle(
                                                  color: Colors.black,
                                                  fontFamily: FontFamily.medium,
                                                  height: 1.2,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textStyle: fontStyle(
                                                  color: Colors.black,
                                                  fontFamily: FontFamily.medium,
                                                  height: 1.2,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                dropDownList: [
                                                  for (int i = 0;
                                                      i < documentDaata.length;
                                                      i++)
                                                    DropDownValueModel(
                                                        name: documentDaata[i]
                                                            .value!,
                                                        value: documentDaata[i]
                                                            .typeid),
                                                ])),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 30),
                                          child: Text(
                                            idtextfieldmodel!.message!.title
                                                .toString(),
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
                                          hintText: '123-XXXX-XXXX',
                                          controller: idcontroller,
                                          validator: (validator) {
                                            if (validator == null ||
                                                validator.isEmpty ||
                                                validator.length !=
                                                    idtextfieldmodel!
                                                        .message!.length) {
                                              return idtextfieldmodel!
                                                  .message!.validationMesage
                                                  .toString();
                                            }
                                            return null;
                                          },
                                        ),
                                        10.verticalSpace,
                                      ],
                                    )
                                  : 0.verticalSpace,

                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 30),
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? "Enter Your Password(min 8 characters)"
                                      : "ادخل كلمة المرور لا تقل عن 8 احرف",
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
                                height: 10,
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 30),
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? "Confirm Your Password"
                                      : "موافقة كلمة المرور",
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

                              InkWell(
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
                                      mobile:
                                          '${selectedcode}${mobileController.text}',
                                      email: emailController.text,
                                      identificationNumber: idcontroller.text,
                                      password: passwordController.text,
                                      userType: "Customer",
                                      indentificationtypeID:
                                          indentificationtypeID,
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
        },
      ),
    );
  }
}
