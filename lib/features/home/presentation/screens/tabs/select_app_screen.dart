import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:huawei_push/huawei_push.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/location.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/Select_type.dart';
import 'package:swa/features/app_info/data/models/country_model.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/Notification/bloc/notification_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/Country_list.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';

import '../../../../../core/utils/huawei_notification_service.dart';

class SelectappScreen extends StatefulWidget {
  const SelectappScreen({super.key});

  @override
  State<SelectappScreen> createState() => _SelectappScreenState();
}

class _SelectappScreenState extends State<SelectappScreen> {
  PackagesBloc packagesBloc = PackagesBloc();
  User? _user;
  bool isHuawei = false;

  Future<bool> isHuaweiDevice() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      return false;
    } else {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer.toLowerCase() == 'huawei';
    }
  }

  void checkDeviceType() async {
    isHuawei = await isHuaweiDevice();
    print("IS HUAWEI $isHuawei");
    if (isHuawei) {
      //HmsPushService.initHMSPushNotifications(context);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkDeviceType();

    super.initState();
    packagesBloc.add(selectappevent());
    BlocProvider.of<GetAvailableCountriesCubit>(context)
        .getAvailableCountries();
    // determinePosition(context).then((value) {
    //
    // });
    BlocProvider.of<LoginCubit>(context).getUserData();
    super.initState();

    setState(() {});
    super.initState();

    BlocProvider.of<PackagesBloc>(context).add(checkversionevent());
  }

  // static Future<void> initHMSPushNotifications(context) async {
  //   print("Started HMS Push Init");
  //   String token = '';
  //   // Enable auto-init
  //   await Push.setAutoInitEnabled(true);
  //
  //   // Request a push token
  //   Push.getToken("");
  //
  //   // Listen to token stream
  //   Push.getTokenStream.listen((String token) {
  //     print('HMS Token: $token');
  //
  //     showDialog(
  //       context: context,
  //       builder: (context) => Dialog(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Text("Token:\n $token\n\n(from HMS init)"),
  //         ),
  //       ),
  //     );
  //
  //     // You can save the token here if needed
  //   });
  //
  //   // Listen for foreground push messages
  //   Push.onMessageReceivedStream.listen((RemoteMessage message) {
  //     print('Received a foreground message: ${message.data}');
  //   });
  //
  //   void _onTokenEvent(
  //     String event,
  //   ) {
  //     // Requested tokens can be obtained here
  //
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         content: Text("Token: ${token} end from _onToken"),
  //       ),
  //     );
  //     log("TokenEvent: " + token);
  //   }
  //
  //   void _onTokenError(Object error) {}
  //
  //   Future<void> initTokenStream() async {
  //     await Push.setAutoInitEnabled(true);
  //     Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
  //   }
  //
  //   initTokenStream();
  //
  //   // Optional: Listen for notification opened or other events if you want
  // }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    // String _token = '';
    // void _onTokenEvent(String event) {
    //   // Requested tokens can be obtained here
    //   setState(() {
    //     _token = event;
    //   });
    //
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       content: Text("Token: ${_token} end from _onToken"),
    //     ),
    //   );
    //   log("TokenEvent: " + _token);
    // }
    //
    // void _onTokenError(Object error) {}
    //
    // Future<void> initTokenStream() async {
    //   await Push.setAutoInitEnabled(true);
    //   if (!mounted) return;
    //   Future.delayed(Duration(seconds: 5), () {
    //     Push.getTokenStream.listen(
    //       _onTokenEvent,
    //       onError: _onTokenError,
    //     );
    //   });
    // }

    // initHMSPushNotifications(context);
    // initTokenStream();

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
                  context.read<NotificationBloc>().add(getNotificationlist());
                }
              }),
          // BlocListener(
          //     bloc: BlocProvider.of<GetAvailableCountriesCubit>(context),
          //     listener: (context, state) async {
          //       if (state is GetAvailableCountriesLoadedState) {
          //         bool? isFirstTime = CacheHelper.getDataToSharedPref(
          //           key: 'locationPermission',
          //         );
          //
          //         if (isFirstTime == null) {
          //           await determinePosition(context);
          //         }
          //
          //         var countryid = CacheHelper.getDataToSharedPref(
          //           key: 'countryid',
          //         );
          //
          //         log('country state   $countryid ' +
          //             countryid.runtimeType.toString());
          //
          //         Routes.countryflag = CacheHelper.getDataToSharedPref(
          //           key: 'countryflag',
          //         );
          //
          //         setState(() {});
          //         LocationPermission permission;
          //
          //         permission = await Geolocator.checkPermission();
          //
          //         if (permission == LocationPermission.denied &&
          //                 countryid == null ||
          //             permission == LocationPermission.deniedForever &&
          //                 countryid == null) {
          //           log('location denied');
          //           List list2 = state.countries.where((element) {
          //             final title = element.Code;
          //
          //             final searc = 'SA';
          //             return title.contains(searc);
          //           }).toList();
          //
          //           if (list2.isEmpty) {
          //             list2 = [
          //               Country(
          //                   countryId: 3,
          //                   countryName: "Saudi Arabia",
          //                   Code: "3",
          //                   Flag:
          //                       "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png",
          //                   curruncy: "SAR")
          //             ];
          //           }
          //           setState(() {});
          //
          //           var flag = CacheHelper.getDataToSharedPref(
          //             key: 'countryflag',
          //           );
          //           if (countryid == null) {
          //             CacheHelper.setDataToSharedPref(
          //                 key: 'countryid', value: list2[0].countryId ?? 3);
          //           }
          //           if (flag == null) {
          //             CacheHelper.setDataToSharedPref(
          //                 key: 'countryflag', value: list2[0].Flag);
          //           }
          //
          //           Routes.countryflag = list2[0].Flag;
          //           Routes.countryflag = list2[0].Flag;
          //
          //           Routes.curruncy = CacheHelper.getDataToSharedPref(
          //                 key: 'curruncycode',
          //               ) ??
          //               list2[0].curruncy;
          //           Routes.country = list2[0].countryName;
          //         } else if (countryid == null || Routes.countryflag == null) {
          //           if (isFirstTime == null) {
          //             await determinePosition(context);
          //           }
          //           List list2 = state.countries.where((element) {
          //             final title = element.Code;
          //             print("Found country code: ${element.Code}");
          //             print(
          //                 "Found country id: ${element.countryId.toString()}");
          //
          //             final searc = Routes.countryname;
          //             return title.contains(searc);
          //           }).toList();
          //
          //           if (list2.isEmpty) {
          //             list2 = [
          //               Country(
          //                   countryId: 3,
          //                   countryName: "Saudi Arabia",
          //                   Code: "3",
          //                   Flag:
          //                       "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png",
          //                   curruncy: "SAR")
          //             ];
          //           }
          //           // setState(() {});
          //
          //           var flag = CacheHelper.getDataToSharedPref(
          //             key: 'countryflag',
          //           );
          //
          //           if (flag == null) {
          //             CacheHelper.setDataToSharedPref(
          //                 key: 'countryflag', value: list2[0].Flag);
          //           }
          //           if (countryid == null) {
          //             CacheHelper.setDataToSharedPref(
          //                 key: 'countryid', value: list2[0].countryId ?? 3);
          //           }
          //
          //           Routes.countryflag = list2[0].Flag;
          //           Routes.countryflag = list2[0].Flag;
          //
          //           Routes.curruncy = CacheHelper.getDataToSharedPref(
          //                 key: 'curruncycode',
          //               ) ??
          //               list2[0].curruncy;
          //           Routes.country = list2[0].countryName;
          //           log('location working ' + Routes.country.toString());
          //         } else {
          //           final list2 = state.countries.where((element) {
          //             final title = element.countryId.toString();
          //
          //             final searc = countryid.toString();
          //             return searc.contains(title);
          //           }).toList();
          //           Routes.curruncy = CacheHelper.getDataToSharedPref(
          //                 key: 'curruncycode',
          //               ) ??
          //               list2[0].curruncy;
          //           Routes.country = list2[0].countryName;
          //
          //           log('location country selected ' +
          //               Routes.curruncy.toString());
          //         }
          //       }
          //
          //       var isFirstTime = CacheHelper.getDataToSharedPref(
          //         key: 'locationPermission',
          //       );
          //
          //       if (isFirstTime) {
          //         await determinePosition(context);
          //       }
          //
          //       var countryId = CacheHelper.getDataToSharedPref(
          //         key: 'countryid',
          //       );
          //
          //       print("Tik Tik COUNTRY ID from select app $countryId");
          //       print(
          //           "Tik Tik COUNTRY Route from select app ${Routes.country}");
          //     }),

          BlocListener(
            bloc: BlocProvider.of<GetAvailableCountriesCubit>(context),
            listener: (context, state) async {
              if (state is GetAvailableCountriesLoadedState) {
                await determinePosition(context, state.countries).then(
                  (value) async {
                    LocationPermission permission =
                        await Geolocator.checkPermission();

                    if (permission == LocationPermission.denied ||
                        permission == LocationPermission.deniedForever ||
                        permission == LocationPermission.unableToDetermine) {
                      print("A77med permission: $permission");
                      // permission = await Geolocator.requestPermission();

                      var countryid = CacheHelper.getDataToSharedPref(
                        key: 'countryid',
                      );
                      if (countryid == null) {
                        Navigator.pushAndRemoveUntil(
                          navigatorKey.currentContext!,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<GetAvailableCountriesCubit>(
                                    create: (context) =>
                                        sl<GetAvailableCountriesCubit>(),
                                    child: CountryListScreen(),
                                  )),
                          (route) => false,
                        );
                      }
                    }
                  },
                );

                final countryId =
                    CacheHelper.getDataToSharedPref(key: 'countryid');
                final flag =
                    CacheHelper.getDataToSharedPref(key: 'countryflag');

                if (countryId != null && flag != null) {
                  final selectedCountry = state.countries.firstWhere(
                    (e) => e.countryId.toString() == countryId.toString(),
                    orElse: () => CountryModel(
                        countryId: state.countries.first.countryId,
                        countryName: state.countries.first.countryName,
                        Code: state.countries.first.Code,
                        Flag: state.countries.first.Flag,
                        curruncy: state.countries.first.curruncy),
                  );

                  Routes.curruncy =
                      CacheHelper.getDataToSharedPref(key: 'curruncycode') ??
                          selectedCountry.curruncy;
                  Routes.country = selectedCountry.countryName;
                  Routes.countryflag = selectedCountry.Flag;

                  log('Country selected: ${Routes.country}, ${Routes.curruncy}');
                }
              }
            },
          )
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
                return PopScope(
                  canPop: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: sizeHeight * 0.1,
                      ),
                      Text(
                        state.selectappmodel?.message?.title ?? '',
                        style: fontStyle(
                            color: Colors.black,
                            fontFamily: FontFamily.bold,
                            fontSize: 24),
                      ),
                      Spacer(),
                      state.selectappmodel?.message != null
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: state
                                  .selectappmodel!.message!.appList!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 50.h),
                                  child: InkWell(
                                    onTap: () {
                                      var countryId =
                                          CacheHelper.getDataToSharedPref(
                                                key: 'countryid',
                                              ) ??
                                              "3";
                                      if (countryId != null) {
                                        if (state.selectappmodel!.message!
                                                .appList![index].orderIndex ==
                                            1) {
                                          Routes.isomra = false;

                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MultiBlocProvider(
                                                        providers: [
                                                          BlocProvider<
                                                              LoginCubit>(
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
                                                            create: (context) =>
                                                                sl<FawryReservation>(),
                                                          ),
                                                          BlocProvider<
                                                              GetAvailableCountriesCubit>(
                                                            create: (context) =>
                                                                sl<GetAvailableCountriesCubit>(),
                                                          ),
                                                          BlocProvider<
                                                              HomeCubit>(
                                                            create: (context) =>
                                                                sl<HomeCubit>(),
                                                          ),
                                                          BlocProvider<
                                                                  TimesTripsCubit>(
                                                              create: (context) =>
                                                                  sl<TimesTripsCubit>()),
                                                          BlocProvider<
                                                                  TicketCubit>(
                                                              create: (context) =>
                                                                  sl<TicketCubit>()),
                                                        ],
                                                        child: MyHome())),
                                            (route) => false,
                                          );
                                        } else if (state
                                                .selectappmodel!
                                                .message!
                                                .appList![index]
                                                .orderIndex ==
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
                                                ],
                                                child: SelectUmratypeScreen(),
                                              ),
                                            ),
                                            (route) => false,
                                          );
                                        }
                                      } else {
                                        // var isFirstTime =
                                        //     CacheHelper.getDataToSharedPref(
                                        //   key: 'locationPermission',
                                        // );
                                        // if (isFirstTime == null) {
                                        //   determinePosition(context,state.c);
                                        // }
                                      }
                                    },
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
                            )
                          : SizedBox(),
                      Spacer(),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
