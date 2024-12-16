import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:badges/badges.dart' as badges;

import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/location.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/custom_drop_down_list.dart';
import 'package:swa/core/widgets/timer.dart';
import 'package:swa/features/app_info/data/data_sources/app_info_remote_data_source.dart';
import 'package:swa/features/app_info/data/models/country_model.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/home/data/models/Notifications_model.dart';
import 'package:swa/features/home/domain/entities/cities_stations.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/Notification/Notification_respotary.dart';
import 'package:swa/features/home/presentation/screens/Notification/Notification_screen.dart';
import 'package:swa/features/home/presentation/screens/Update_screen/update_screen.dart';
import 'package:swa/features/home/presentation/screens/home.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/my_account.dart';
import 'package:swa/features/home/presentation/screens/select_from_city/select_from_city.dart';
import 'package:swa/features/home/presentation/screens/select_to_city/select_to_city.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/Ads_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/widgets/carousel_widget.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_states.dart';
import 'package:swa/features/times_trips/presentation/screens/times_screen.dart';
import 'package:swa/main.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool isTabbed = false;
  int currentIndex = 0;
  DateTime selectedDayFrom = DateTime.now();
  DateTime selectedDayTo = DateTime.now().add(Duration(days: 1));
  List<CitiesStations>? _fromStations;
  List<CitiesStations>? _toStations;
  List<dynamic> tripList = [];
  List<dynamic> tripListBack = [];

  ///To be changed by selected station id
  int? _fromStationId;
  int? _toStationId;
  String _fromCityName = '';
  String _toCityName = '';

  List<Country> countries = [];
  Country? dropdownvalue;

  ///Getting if user is logged in or not
  User? _user;
  String tripTypeId = "1";

  bool opencountrydialog = false;

  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  void updateNotificationCount(int newCount) {
    setState(() {
      count = newCount;
    });
  }

  int? count;
  bool isRefreshing = false;
  NotificationModel? model;
  Future<void> get() async {
    isRefreshing = true; // Set a flag to indicate a refresh is in progress.
    final result = await NotifcationRespo().getNotifications();
    if (result != null) {
      model = result;
      // Calculate the count with IsRead as false
      count = model?.notifications
              .where((notification) => !notification.IsRead!)
              .length ??
          0;
    }
    isRefreshing = false;
    // PackageTermsCubit.get(context).getPackageTerms();// Reset the flag after refreshing.
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
      BlocProvider.of<GetAvailableCountriesCubit>(context)
          .getAvailableCountries();

      setState(() {});
    });
    super.initState();
    Ticketreservation.Seatsnumbers1.clear();
    Ticketreservation.Seatsnumbers2.clear();

    BlocProvider.of<PackagesBloc>(context).add(GetadsEvent());
    BlocProvider.of<PackagesBloc>(context).add(checkversionevent());
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          BlocListener(
            bloc: BlocProvider.of<LoginCubit>(context),
            listener: (BuildContext context, state) async {
              if (state is UserLoginLoadedState) {
                _user = state.userResponse.user;

                Routes.user = state.userResponse.user;

                if (state.userResponse.status == 'success') {}

                get();
                BlocProvider.of<PackagesBloc>(context).add(GetpopupadsEvent());
              }
            },
          ),
          BlocListener(
            bloc: BlocProvider.of<PackagesBloc>(context),
            listener: (BuildContext context, state) async {
              if (state is PackagesState) {
                if (state.updateversion == 'success') {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateAppScreen()));
                }
                if (state.advModel?.status == 'success') {
                  for (var element in state.advModel!.message!) {
                    showGeneralDialog(
                        context: context,
                        pageBuilder: (BuildContext buildContext,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return StatefulBuilder(builder: (context, setStater) {
                            return Container(
                              color: Colors.transparent,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 0,
                                child: InkWell(
                                  onTap: () {
                                    if (element.linkApi != null) {
                                      _launchInWebView(
                                          Uri.parse(element.linkApi!));
                                    }
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.4,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 5),
                                          child: Image.network(
                                            element.icon!,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.4,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: InkWell(
                                            onTap: () {
                                              PackagesRespo().closeadsfunc(
                                                  id: element
                                                      .adCustomerAppWebViewId);

                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                  }
                }
              }
            },
          ),
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

                  countries = state.countries;

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
                    Routes.curruncy = list2[0].curruncy;
                    Routes.country = list2[0].countryName;

                    dropdownvalue = list2[0];

                    print('A777777a' + countryid.toString());
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
                    Routes.curruncy = list2[0].curruncy;
                    Routes.country = list2[0].countryName;

                    dropdownvalue = list2[0];
                  } else {
                    final list2 = state.countries.where((element) {
                      final title = element.countryId.toString();

                      final searc = countryid.toString();
                      return title.contains(searc);
                    }).toList();
                    dropdownvalue = list2[0];
                    Routes.curruncy = list2[0].curruncy;
                    Routes.country = list2[0].countryName;
                  }
                }
              }),
        ],
        child: Directionality(
          textDirection:
              LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: sizeHeight * 0.38,
                  width: sizeWidth,
                  color: Color(0xffFF5D4B),
                  child: Stack(
                    children: [
                      BlocBuilder(
                        bloc: BlocProvider.of<PackagesBloc>(context),
                        builder: (context, PackagesState state) {
                          return Container(
                            height: sizeHeight * 0.38,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: CarouselWidget(items: [
                              ...List<Widget>.generate(
                                state.adsModel!.message!.length ?? 0,
                                (index) => contentAdvertisment(
                                    state.adsModel!.message![index],
                                    sizeHeight),
                              ),
                            ]),
                          );
                        },
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: sizeWidth * 0.18,
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                          "assets/images/homelogo.png"),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Routes.user == null
                                        ? SizedBox()
                                        : Stack(
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return NotificationScreen(
                                                        isScreenHome: false,
                                                        updateNotificationCount:
                                                            updateNotificationCount,
                                                      );
                                                    }));
                                                  },
                                                  icon: Icon(
                                                    Icons.notifications,
                                                    size: 25,
                                                    color: Colors.white,
                                                  )),
                                              model == null ||
                                                      model!
                                                          .notifications.isEmpty
                                                  ? SizedBox()
                                                  : count == 0
                                                      ? const SizedBox()
                                                      : Positioned(
                                                          top: -2,
                                                          right: 0,
                                                          child: badges.Badge(
                                                            badgeContent: Text(
                                                              count.toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                            ),
                                                            badgeStyle: badges.BadgeStyle(
                                                                badgeColor:
                                                                    AppColors
                                                                        .darkPurple,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            5)),
                                                          ),
                                                        )
                                            ],
                                          ),
                                    Routes.user == null
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, Routes.signInRoute);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 87,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: AppColors.white,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 12,
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        "assets/images/Icon open-account-lo.png"),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? "Login"
                                                        : 'دخول',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontFamily: 'regular'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return MyAccountScreen(
                                                  loginLocalDataSource: sl(),
                                                  user: Routes.user!,
                                                );
                                              })).then((value) {
                                                BlocProvider.of<LoginCubit>(
                                                        context)
                                                    .getUserData();
                                              });
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 87,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              // width: sizeWidth * 0.3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: AppColors.white,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      Routes.user!.name!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'regular'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                tripTypeId = "1";
                                setState(() {
                                  print("tripTypeId");
                                });
                              },
                              child: Container(
                                height: 70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/arrow_one_way.svg",
                                      width: 40,
                                      height: 40,
                                      color: tripTypeId == "1"
                                          ? AppColors.primaryColor
                                          : Color(0xffdddddd),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Text(
                                      LanguageClass.isEnglish
                                          ? "One way"
                                          : "ذهاب فقط",
                                      style: TextStyle(
                                          color: tripTypeId == "1"
                                              ? AppColors.primaryColor
                                              : Color(0xffdddddd),
                                          fontSize: 18,
                                          fontFamily: 'regular',
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            InkWell(
                              onTap: () {
                                tripTypeId = "2";
                                setState(() {
                                  print("tripTypeId");
                                });
                              },
                              child: Container(
                                height: 70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/bus.svg",
                                      width: 40,
                                      height: 40,
                                      color: tripTypeId == "2"
                                          ? AppColors.primaryColor
                                          : Color(0xffdddddd),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Text(
                                      LanguageClass.isEnglish
                                          ? "Round Trip"
                                          : "ذهاب وعوده",
                                      style: TextStyle(
                                          color: tripTypeId == "2"
                                              ? AppColors.primaryColor
                                              : Color(0xffdddddd),
                                          fontSize: 18,
                                          fontFamily: 'regular',
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: _toStationId == null ||
                                        _fromStationId == null
                                    ? () {}
                                    : () {
                                        String to;
                                        int? toid;

                                        toid = _toStationId;
                                        to = _toCityName;

                                        _toStationId = _fromStationId;

                                        _toCityName = _fromCityName;

                                        _fromCityName = to;

                                        _fromStationId = toid;
                                        setState(() {});
                                      },
                                child: Icon(
                                  Icons.swap_vert,
                                  color: AppColors.primaryColor,
                                  size: 40,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    LanguageClass.isEnglish ? "From" : "من",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: LanguageClass.isEnglish
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                  BlocListener(
                                    bloc: BlocProvider.of<HomeCubit>(context),
                                    listener:
                                        (BuildContext context, state) async {
                                      if (state
                                          is GetFromStationsListLoadingState) {
                                        Constants.showLoadingDialog(context);
                                      } else if (state
                                          is GetFromStationsListLoadedState) {
                                        Constants.hideLoadingDialog(context);
                                        setState(() {
                                          if (state
                                                  .homeMessageResponse.status ==
                                              'failed') {
                                            Constants.showDefaultSnackBar(
                                                context: context,
                                                text: state
                                                    .homeMessageResponse.message
                                                    .toString());
                                          } else {
                                            _fromStations = state
                                                .homeMessageResponse
                                                .citiesStations!
                                                .cast<CitiesStations>()
                                                .toList();
                                          }
                                        });
                                        final result = await Navigator.push(
                                            context, MaterialPageRoute(
                                                builder: (context) {
                                          return SelectFromCity(
                                              fromStations: _fromStations!);
                                        }));
                                        if (result != null) {
                                          setState(() {
                                            _fromStationId =
                                                result['_fromStationId'];
                                            _fromCityName =
                                                result['_fromCityName'];
                                          });
                                        }
                                        // Widget _fromStationsListWidget = ListView.builder(
                                        //   scrollDirection: Axis.vertical,
                                        //   shrinkWrap: true,
                                        //   itemCount: _fromStations!.length,
                                        //   itemBuilder: (context, index) {
                                        //     String cityName = _fromStations![index].cityName;
                                        //     List<StationList> stationsList = _fromStations![index].stationList;
                                        //     return stationsList.isNotEmpty ? Material(
                                        //       child: ExpansionTile(
                                        //         backgroundColor: Colors.grey[200],
                                        //         iconColor: AppColors.primaryColor,
                                        //         title: Text(
                                        //           cityName,
                                        //           style: const TextStyle(
                                        //               color: Colors.black,
                                        //               fontWeight: FontWeight.bold
                                        //           ),
                                        //         ),
                                        //         children: [
                                        //           ListView.builder(
                                        //             shrinkWrap: true,
                                        //             physics: const ClampingScrollPhysics(),//NeverScrollableScrollPhysics(),
                                        //             scrollDirection: Axis.vertical,
                                        //             itemCount: stationsList.length,
                                        //             itemBuilder: (context, index) {
                                        //               return ListTile(
                                        //                 onTap: (){
                                        //                   setState(() {
                                        //                     _fromStationId = stationsList[index].stationId;
                                        //                     _fromCityName = stationsList[index].stationName;
                                        //                   });
                                        //                   Navigator.of(context).pop();
                                        //                 },
                                        //                 leading: IconButton(
                                        //                   icon: Icon(
                                        //                     Icons.arrow_forward_ios_outlined,
                                        //                     size: 20,
                                        //                     color: AppColors.primaryColor,
                                        //                   ),
                                        //                   onPressed: () {
                                        //                   },
                                        //                 ),
                                        //                 title: Text(stationsList[index].stationName),
                                        //               );
                                        //             },
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ) : const SizedBox(width: 60,);
                                        //   },
                                        // );
                                        // Constants.showListDialog(context, 'From Stations', _fromStationsListWidget);
                                      } else if (state
                                          is GetFromStationsListErrorState) {
                                        Constants.hideLoadingDialog(context);
                                        Constants.showDefaultSnackBar(
                                            context: context,
                                            text: state.error.toString());
                                      }
                                    },
                                    child: InkWell(
                                        onTap: () {
                                          BlocProvider.of<HomeCubit>(context)
                                              .getFromStationsListData();
                                        },
                                        child: CustomDropDownList(
                                            hint: _fromCityName == ''
                                                ? LanguageClass.isEnglish
                                                    ? 'Select'
                                                    : 'تحديد'
                                                : _fromCityName)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      LanguageClass.isEnglish ? "To" : "الي",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      textAlign: LanguageClass.isEnglish
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                  BlocListener(
                                    bloc: BlocProvider.of<HomeCubit>(context),
                                    listener:
                                        (BuildContext context, state) async {
                                      if (state
                                          is GetToStationsListLoadingState) {
                                        Constants.showLoadingDialog(context);
                                      } else if (state
                                          is GetToStationsListLoadedState) {
                                        Constants.hideLoadingDialog(context);
                                        setState(() {
                                          if (state
                                                  .homeMessageResponse.status ==
                                              'failed') {
                                            Constants.showDefaultSnackBar(
                                                context: context,
                                                text: state
                                                    .homeMessageResponse.message
                                                    .toString());
                                          } else {
                                            _toStations = state
                                                .homeMessageResponse
                                                .citiesStations!
                                                .cast<CitiesStations>()
                                                .toList();
                                          }
                                        });
                                        final result = await Navigator.push(
                                            context, MaterialPageRoute(
                                                builder: (context) {
                                          return SelectToCity(
                                              toStations: _toStations!);
                                        }));
                                        if (result != null) {
                                          setState(() {
                                            _toStationId =
                                                result['_toStationId'];
                                            _toCityName = result['_toCityName'];
                                          });
                                        }
                                      } else if (state
                                          is GetToStationsListErrorState) {
                                        Constants.hideLoadingDialog(context);
                                        Constants.showDefaultSnackBar(
                                            context: context,
                                            text: state.error.toString());
                                      }
                                    },
                                    child: InkWell(
                                        onTap: () {
                                          if (_fromStationId != null) {
                                            BlocProvider.of<HomeCubit>(context)
                                                .getToStationsListData(
                                                    ToStationsParams(
                                                        stationId:
                                                            _fromStationId
                                                                .toString()));
                                          }
                                        },
                                        child: CustomDropDownList(
                                            hint: _toCityName == ''
                                                ? LanguageClass.isEnglish
                                                    ? 'Select'
                                                    : 'تحديد'
                                                : _toCityName)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            children: [
                              tripTypeId == "1"
                                  ? InkWell(
                                      onTap: () {
                                        showMyDatePicker(selectedDayFrom);
                                        setState(() {
                                          selectedDayFrom;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.date_range_outlined,
                                                    color: AppColors.blackColor,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: sizeWidth * 0.01,
                                                  ),
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? "DEPART ON"
                                                        : "تغادر من",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                              InkWell(
                                                child: Text(
                                                    "${selectedDayFrom.day}/${selectedDayFrom.month}/${selectedDayFrom.year}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize: 20)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              showMyDatePicker(selectedDayFrom);
                                              setState(() {
                                                selectedDayFrom;
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.date_range_outlined,
                                                      color:
                                                          AppColors.blackColor,
                                                      size: 16,
                                                    ),
                                                    SizedBox(
                                                      width: sizeWidth * 0.01,
                                                    ),
                                                    Text(
                                                      LanguageClass.isEnglish
                                                          ? "DEPART ON GO"
                                                          : " تغادر من ذهاب",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                                InkWell(
                                                  child: Text(
                                                      "${selectedDayFrom.day}/${selectedDayFrom.month}/${selectedDayFrom.year}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: 16)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              showMyDatePicker(selectedDayTo);
                                              setState(() {
                                                selectedDayTo;
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.date_range_outlined,
                                                      color:
                                                          AppColors.blackColor,
                                                      size: 16,
                                                    ),
                                                    SizedBox(
                                                      width: sizeWidth * 0.01,
                                                    ),
                                                    Text(
                                                      LanguageClass.isEnglish
                                                          ? "DEPART ON BACK"
                                                          : " تغادر من عودة",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                                InkWell(
                                                  child: Text(
                                                      "${selectedDayTo.day}/${selectedDayTo.month}/${selectedDayTo.year}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: 16)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                child: BlocListener<TimesTripsCubit,
                                    TimesTripsStates>(
                                  bloc:
                                      BlocProvider.of<TimesTripsCubit>(context),
                                  listener: (context, state) {
                                    if (state is LoadingTimesTrips) {
                                      Constants.showLoadingDialog(context);
                                    } else if (state is LoadedTimesTrips) {
                                      tripListBack = state.timesTripsResponse
                                              .message!.tripListBack ??
                                          [];
                                      Constants.hideLoadingDialog(context);

                                      if (state.timesTripsResponse.message!
                                          .tripList!.isNotEmpty) {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TimesScreen(
                                            tripList: state.timesTripsResponse
                                                .message!.tripList!,
                                            tripTypeId: tripTypeId,
                                            tripListBack: state
                                                    .timesTripsResponse
                                                    .message!
                                                    .tripListBack ??
                                                [],
                                          );
                                        })).then((value) {
                                          Reservationtimer.stoptimer();

                                          Ticketreservation.Seatsnumbers1
                                              .clear();
                                          Ticketreservation.Seatsnumbers2
                                              .clear();
                                        });
                                      } else {
                                        Constants.showDefaultSnackBar(
                                            context: context,
                                            text: LanguageClass.isEnglish
                                                ? "No trips in this date"
                                                : "لا يوجد مواعيد في هذا الموعد");
                                      }
                                    } else if (state is ErrorTimesTrips) {
                                      Constants.hideLoadingDialog(context);
                                      Constants.showDefaultSnackBar(
                                          context: context, text: state.msg);
                                    }
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      if (_fromStationId == null ||
                                          _toStationId == null) {
                                        Constants.showDefaultSnackBar(
                                            context: context,
                                            text: LanguageClass.isEnglish
                                                ? "please select from city and to city"
                                                : " برجاء تحديد المدينة ");
                                      } else {
                                        print(
                                            "tripTypeIdBassant    ${_fromStationId.toString()}  ${_toStationId.toString()}"
                                            "  ${selectedDayFrom.toString()}  ${selectedDayTo.toString()}");
                                        CacheHelper.setDataToSharedPref(
                                            key: 'fromStationId',
                                            value: _fromStationId.toString());
                                        CacheHelper.setDataToSharedPref(
                                            key: 'toStationId',
                                            value: _toStationId.toString());
                                        CacheHelper.setDataToSharedPref(
                                            key: 'selectedDayTo',
                                            value: selectedDayTo.toString());
                                        CacheHelper.setDataToSharedPref(
                                            key: 'selectedDayFrom',
                                            value: selectedDayFrom.toString());
                                        print("===}======");
                                        BlocProvider.of<TimesTripsCubit>(
                                                context)
                                            .getTimes(
                                          tripType: tripTypeId.toString(),
                                          fromStationID:
                                              _fromStationId.toString(),
                                          toStationID: _toStationId.toString(),
                                          dateGo: selectedDayFrom.toString(),
                                          dateBack: selectedDayTo.toString(),
                                        );
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      height: 50,
                                      //padding:  EdgeInsets.symmetric(horizontal: 10,vertical:20),
                                      //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(41)),
                                      child: Center(
                                        child: Text(
                                          LanguageClass.isEnglish
                                              ? "Search Bus"
                                              : "بحث عن الاتوبيس",
                                          style: TextStyle(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMyDatePicker(DateTime selectedDay) async {
    DateTime? newSelectedDay = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newSelectedDay != null) {
      setState(() {
        if (selectedDay == selectedDayFrom) {
          selectedDayFrom = newSelectedDay;
        } else if (selectedDay == selectedDayTo) {
          selectedDayTo = newSelectedDay;
        }
      });
    }
  }
}
