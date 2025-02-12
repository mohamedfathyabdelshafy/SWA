import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/app_info/domain/entities/city.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_country_cities_cubit/get_available_country_cities_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/data/model/personal_info_response.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/data/repo/personal_info_repo.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/PLOH/personal_info_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/PLOH/personal_info_states.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_up/presentation/screens/component/city_drop_down_button.dart';
import 'package:swa/features/sign_up/presentation/screens/component/country_drop_down_button.dart';
import 'package:swa/main.dart';

class PersonalInfoScreen extends StatefulWidget {
  PersonalInfoScreen({super.key, required this.user});
  User user;
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  PersonalInfoRepo personalInfoRepo = PersonalInfoRepo(sl());
  PersonalInfoResponse? personalInfoResponse;
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController Codecontroller = TextEditingController();

  TextEditingController mobilController = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  TextEditingController cityController = TextEditingController();

  Country? _selectedCountry;
  City? _selectedCity;
  int? countryid;
  int? cityid;

  bool changed = false;

  @override
  void initState() {
    get();

    super.initState();
  }

  void get() async {
    personalInfoResponse = await personalInfoRepo.getPersonalInfo(
        customerId: widget.user.customerId!);
    nameController.text = personalInfoResponse!.personalInfo!.name!;
    emailController.text = personalInfoResponse!.personalInfo!.email!;
    Codecontroller.text =
        personalInfoResponse!.personalInfo!.customerCode.toString();
    mobilController.text = personalInfoResponse!.personalInfo!.mobile!;
    countrycontroller.text = personalInfoResponse!.personalInfo!.countryName!;
    cityController.text = personalInfoResponse!.personalInfo!.cityName!;
    countryid = personalInfoResponse!.personalInfo!.countryId!;

    cityid = personalInfoResponse!.personalInfo!.cityId!;

    setState(() {});
    print("personalInfoResponse${personalInfoResponse!.personalInfo!.name!}");
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: sizeHeight * 0.08,
              ),
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
                    color: Routes.isomra
                        ? AppColors.umragold
                        : AppColors.primaryColor,
                    size: 35,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  LanguageClass.isEnglish
                      ? "Personal Information"
                      : "معلومات شخصية",
                  style: fontStyle(
                      color: AppColors.blackColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.medium),
                ),
              ),
              SizedBox(
                height: sizeHeight * 0.01,
              ),
              CustomizedField(
                onchange: (v) {
                  setState(() {
                    changed = true;
                  });
                },
                colorText: Colors.black,
                borderradias: 12,
                labelcolor:
                    Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
                bordercolor: Colors.black,
                isPassword: false,
                obscureText: false,
                color: Color(0xffDDDDDD),
                controller: nameController,
                validator: (validator) {},
                labelText: LanguageClass.isEnglish ? "Name" : "الاسم",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomizedField(
                colorText: Colors.black,
                onchange: (v) {
                  setState(() {
                    changed = true;
                  });
                },
                labelcolor:
                    Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
                borderradias: 12,
                isPassword: false,
                obscureText: false,
                bordercolor: Colors.black,
                color: Color(0xffDDDDDD),
                controller: mobilController,
                validator: (validator) {},
                labelText: LanguageClass.isEnglish ? "Mobile" : "موبيل",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomizedField(
                colorText: Colors.black,
                labelcolor:
                    Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
                onchange: (v) {
                  setState(() {
                    changed = true;
                  });
                },
                borderradias: 12,
                isPassword: false,
                bordercolor: Colors.black,
                obscureText: false,
                color: Color(0xffDDDDDD),
                controller: emailController,
                readonly: true,
                validator: (validator) {},
                labelText: LanguageClass.isEnglish ? "Email" : "الايميل",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomizedField(
                colorText: Colors.black,
                onchange: (v) {
                  setState(() {
                    changed = true;
                  });
                },
                labelcolor:
                    Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
                borderradias: 12,
                bordercolor: Colors.black,
                isPassword: false,
                obscureText: false,
                color: Color(0xffDDDDDD),
                controller: Codecontroller,
                readonly: true,
                validator: (validator) {},
                labelText: LanguageClass.isEnglish ? "Code" : "كود",
              ),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<GetAvailableCountriesCubit,
                  GetAvailableCountriesCubitState>(builder: (context, state) {
                return state is GetAvailableCountriesLoadedState
                    ? CountryDropDownTextFieldButton(
                        countries: state.countries,
                        controller: countrycontroller,
                        borderradias: 12,
                        hintText: _selectedCountry?.countryName != null
                            ? _selectedCountry!.countryName
                            : countrycontroller.text,
                        onSelect: (country) {
                          setState(() {
                            _selectedCountry = country;
                            countryid = country.countryId;
                            _selectedCity = null;
                            changed = true;
                          });
                          BlocProvider.of<GetAvailableCountryCitiesCubit>(
                                  context)
                              .getAvailableCountries(
                                  _selectedCountry!.countryId);
                        },
                      )
                    : CustomizedField(
                        colorText: Colors.black,
                        labelcolor: Routes.isomra
                            ? AppColors.umragold
                            : AppColors.primaryColor,
                        onchange: (v) {
                          setState(() {
                            changed = true;
                          });
                        },
                        borderradias: 12,
                        bordercolor: Colors.black,
                        isPassword: false,
                        obscureText: false,
                        readonly: true,
                        color: Color(0xffDDDDDD),
                        controller: countrycontroller,
                        ontap: () {
                          BlocProvider.of<GetAvailableCountriesCubit>(context)
                              .getAvailableCountries();
                        },
                        validator: (validator) {},
                        labelText:
                            LanguageClass.isEnglish ? "Country" : "الدولة",
                      );
              }),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<GetAvailableCountryCitiesCubit,
                      GetAvailableCountryCitiesCubitState>(
                  builder: (context, state) {
                return state is GetAvailableCountryCitiesLoadedState
                    ? CityDropDownTextFieldButton(
                        countries: state.countryCities,
                        borderradias: 12,
                        hintText: _selectedCity?.cityName != null
                            ? _selectedCity!.cityName
                            : cityController.text,
                        controller: cityController,
                        onSelect: (city) {
                          setState(() {
                            _selectedCity = city;
                            cityid = city.cityId;
                            changed = true;
                          });
                        },
                      )
                    : CustomizedField(
                        colorText: Colors.black,
                        onchange: (v) {
                          setState(() {
                            changed = true;
                          });
                        },
                        borderradias: 12,
                        isPassword: false,
                        labelcolor: Routes.isomra
                            ? AppColors.umragold
                            : AppColors.primaryColor,
                        obscureText: false,
                        readonly: true,
                        color: Color(0xffDDDDDD),
                        bordercolor: Colors.black,
                        controller: cityController,
                        validator: (validator) {},
                        labelText: LanguageClass.isEnglish ? "City" : "المدينة",
                      );
              }),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: personalInfoResponse?.personalInfo?.customerCode == null
                    ? SizedBox()
                    : QrImageView(
                        data:
                            '${personalInfoResponse?.personalInfo?.customerCode}${personalInfoResponse?.personalInfo?.customerID}',
                        version: QrVersions.auto,
                        size: 100,
                      ),
              ),
              SizedBox(
                height: 15,
              ),
              changed == true
                  ? BlocListener<PersonalInfoCubit, PersonalInfoStates>(
                      listener: (contex, state) {
                        if (state is PersonalInfoLoading) {
                          Constants.showLoadingDialog(context);
                        }
                        if (state is PersonalInfoLoaded) {
                          Constants.hideLoadingDialog(context);
                          Constants.showDefaultSnackBar(
                              context: context,
                              text: state.personalInfoResponse.message!);
                        }
                        if (state is PersonalInfoError) {
                          Constants.hideLoadingDialog(context);
                          Constants.showDefaultSnackBar(
                              context: context, text: state.msg);
                        }
                      },
                      child: InkWell(
                        onTap: () {
                          BlocProvider.of<PersonalInfoCubit>(context)
                              .getPersonalInfoEdit(
                                  customerId: widget.user.customerId!,
                                  name: nameController.text,
                                  mobile: mobilController.text,
                                  email: emailController.text,
                                  countryId: countryid!,
                                  cityid: cityid!,
                                  userLoginId: widget.user.userId!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Constants.customButton(
                            borderradias: 41,
                            text: LanguageClass.isEnglish ? "Save" : "حفظ",
                            color: Routes.isomra
                                ? AppColors.umragold
                                : AppColors.primaryColor,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
