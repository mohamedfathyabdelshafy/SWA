import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/location.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/Select_type.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/home.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';

class SelectappScreen extends StatefulWidget {
  SelectappScreen({super.key});

  @override
  State<SelectappScreen> createState() => _SelectappScreenState();
}

class _SelectappScreenState extends State<SelectappScreen> {
  PackagesBloc packagesBloc = PackagesBloc();
  User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packagesBloc.add(selectappevent());

    BlocProvider.of<LoginCubit>(context).getUserData();
    super.initState();
    BlocProvider.of<GetAvailableCountriesCubit>(context)
        .getAvailableCountries();

    setState(() {});
    super.initState();

    BlocProvider.of<PackagesBloc>(context).add(checkversionevent());
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Color(0xffEFEFEF),
      body: MultiBlocListener(
        listeners: [
          BlocListener(
              bloc: BlocProvider.of<LoginCubit>(context),
              listener: (context, state) {
                if (state is UserLoginLoadedState) {
                  _user = state.userResponse.user;

                  Routes.customerid = state.userResponse.user!.customerId;
                  Routes.user = state.userResponse.user;
                }
              }),
          BlocListener(
              bloc: BlocProvider.of<GetAvailableCountriesCubit>(context),
              listener: (context, state) async {
                if (state is GetAvailableCountriesLoadedState) {
                  var countryid = CacheHelper.getDataToSharedPref(
                    key: 'countryid',
                  );

                  Routes.countryflag = CacheHelper.getDataToSharedPref(
                    key: 'countryflag',
                  );

                  setState(() {});

                  if (await Permission.location.isDenied && countryid == null ||
                      await Permission.location.isPermanentlyDenied &&
                          countryid == null) {
                    List list2 = state.countries.where((element) {
                      final title = element.Code;

                      final searc = 'EG';
                      return title.contains(searc);
                    }).toList();

                    if (list2.isEmpty) {
                      list2 = [
                        Country(
                            countryId: 1,
                            countryName: "Egypt",
                            Code: "1",
                            Flag:
                                "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png",
                            curruncy: "EGP")
                      ];
                    }
                    setState(() {});

                    CacheHelper.setDataToSharedPref(
                        key: 'countryid', value: list2[0].countryId ?? '1');
                    CacheHelper.setDataToSharedPref(
                        key: 'countryflag', value: list2[0].Flag);

                    Routes.countryflag = list2[0].Flag;
                    Routes.countryflag = list2[0].Flag;
                    Routes.curruncy = CacheHelper.getDataToSharedPref(
                          key: 'curruncycode',
                        ) ??
                        list2[0].curruncy;
                    Routes.country = list2[0].countryName;
                  } else if (countryid == null || Routes.countryflag == null) {
                    await determinePosition();

                    List list2 = state.countries.where((element) {
                      final title = element.Code;

                      final searc = Routes.countryname;
                      return title.contains(searc);
                    }).toList();

                    if (list2.isEmpty) {
                      list2 = [
                        Country(
                            countryId: 1,
                            countryName: "Egypt",
                            Code: "1",
                            Flag:
                                "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png",
                            curruncy: "EGP")
                      ];
                    }
                    setState(() {});

                    CacheHelper.setDataToSharedPref(
                        key: 'countryid', value: list2[0].countryId ?? '1');
                    CacheHelper.setDataToSharedPref(
                        key: 'countryflag', value: list2[0].Flag);
                    Routes.countryflag = list2[0].Flag;
                    Routes.countryflag = list2[0].Flag;
                    Routes.curruncy = CacheHelper.getDataToSharedPref(
                          key: 'curruncycode',
                        ) ??
                        list2[0].curruncy;
                    Routes.country = list2[0].countryName;
                  } else {
                    final list2 = state.countries.where((element) {
                      final title = element.countryId.toString();

                      final searc = countryid.toString();
                      return title.contains(searc);
                    }).toList();
                    Routes.curruncy = CacheHelper.getDataToSharedPref(
                          key: 'curruncycode',
                        ) ??
                        list2[0].curruncy;
                    Routes.country = list2[0].countryName;
                  }
                }
              }),
        ],
        child: BlocBuilder(
            bloc: packagesBloc,
            builder: (context, PackagesState state) {
              if (state.isloading == true) {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ));
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: sizeHeight * 0.1,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        state.selectappmodel?.message?.title ?? '',
                        style: fontStyle(
                            color: Colors.black,
                            fontFamily: FontFamily.bold,
                            fontSize: 24),
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight * 0.08,
                    ),
                    state.selectappmodel?.message != null
                        ? Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: state
                                  .selectappmodel!.message!.appList!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    if (state.selectappmodel!.message!
                                            .appList![index].orderIndex ==
                                        1) {
                                      Routes.isomra = false;

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MultiBlocProvider(providers: [
                                                  BlocProvider<LoginCubit>(
                                                    create: (context) =>
                                                        sl<LoginCubit>(),
                                                  ),
                                                  BlocProvider<PackagesBloc>(
                                                    create: (context) =>
                                                        PackagesBloc(),
                                                  ),
                                                  BlocProvider<
                                                      FawryReservation>(
                                                    create: (context) =>
                                                        sl<FawryReservation>(),
                                                  ),
                                                  BlocProvider<
                                                      GetAvailableCountriesCubit>(
                                                    create: (context) => sl<
                                                        GetAvailableCountriesCubit>(),
                                                  ),
                                                  BlocProvider<HomeCubit>(
                                                    create: (context) =>
                                                        sl<HomeCubit>(),
                                                  ),
                                                  BlocProvider<TimesTripsCubit>(
                                                      create: (context) => sl<
                                                          TimesTripsCubit>()),
                                                  BlocProvider<TicketCubit>(
                                                      create: (context) =>
                                                          sl<TicketCubit>()),
                                                ], child: MyHome())),
                                        (route) => false,
                                      );
                                    } else if (state.selectappmodel!.message!
                                            .appList![index].orderIndex ==
                                        2) {
                                      Routes.isomra = true;

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider<LoginCubit>(
                                                        create: (context) =>
                                                            sl<LoginCubit>(),
                                                      ),
                                                      BlocProvider<
                                                          PackagesBloc>(
                                                        create: (context) =>
                                                            PackagesBloc(),
                                                      ),
                                                      BlocProvider<
                                                          FawryReservation>(
                                                        create: (context) => sl<
                                                            FawryReservation>(),
                                                      ),
                                                      BlocProvider<
                                                          GetAvailableCountriesCubit>(
                                                        create: (context) => sl<
                                                            GetAvailableCountriesCubit>(),
                                                      ),
                                                      BlocProvider<HomeCubit>(
                                                        create: (context) =>
                                                            sl<HomeCubit>(),
                                                      ),
                                                      BlocProvider<
                                                              TimesTripsCubit>(
                                                          create: (context) => sl<
                                                              TimesTripsCubit>()),
                                                      BlocProvider<TicketCubit>(
                                                          create: (context) =>
                                                              sl<TicketCubit>()),
                                                    ],
                                                    child:
                                                        SelectUmratypeScreen())),
                                        (route) => false,
                                      );
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 30.h),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 156.w,
                                          height: 156.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          alignment: Alignment.center,
                                          child: Image.network(
                                            state.selectappmodel!.message!
                                                .appList![index].image!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        5.verticalSpace,
                                        Text(
                                          state
                                                  .selectappmodel
                                                  ?.message
                                                  ?.appList?[index]
                                                  .description ??
                                              '',
                                          style: fontStyle(
                                              color: Color(0xffa3a3a3),
                                              fontFamily: FontFamily.medium,
                                              fontSize: 13.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                );
              }
            }),
      ),
    );
  }
}
