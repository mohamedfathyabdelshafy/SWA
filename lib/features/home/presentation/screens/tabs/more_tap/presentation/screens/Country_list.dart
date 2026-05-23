import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<GetAvailableCountriesCubit>(context).getAvailableCountries();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<GetAvailableCountriesCubit, GetAvailableCountriesCubitState>(
            builder: (context, state) {
              return state is GetAvailableCountriesLoadedState
                  ? SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              LanguageClass.isEnglish ? "Select your country" : "اختر الدولة",
                              style: fontStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: FontFamily.medium),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Routes.curruncy = state.countries[index].curruncy;
                                          CacheHelper.setDataToSharedPref(
                                            key: 'curruncycode',
                                            value: state.countries[index].curruncy,
                                          );

                                          Routes.country = state.countries[index].countryName;
                                          setState(() {
                                            CacheHelper.setDataToSharedPref(
                                              key: 'countryid',
                                              value: state.countries[index].countryId.toString(),
                                            );
                                            CacheHelper.setDataToSharedPref(
                                              key: 'countryflag',
                                              value: state.countries[index].Flag,
                                            );
                                            Routes.countryflag = state.countries[index].Flag;
                                          });
                                          Routes.curruncy = state.countries[index].curruncy;
                                          CacheHelper.setDataToSharedPref(
                                            key: 'curruncycode',
                                            value: state.countries[index].curruncy,
                                          );

                                          Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false,
                                              arguments: Routes.isomra);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                          child: Text(
                                            state.countries[index].countryName,
                                            style: fontStyle(
                                                fontFamily: FontFamily.bold, color: Color(0xffA3A3A3), fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: Colors.black,
                                  );
                                },
                                itemCount: state.countries.length),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
                      ),
                    );
            },
          ),
        ));
  }
}
