import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:huawei_push/huawei_push.dart';
import 'package:intl/intl.dart' as intl;
import 'package:jhijri/jHijri.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/custom_drop_down_list.dart';
import 'package:swa/core/widgets/notifications_icon.dart';
import 'package:swa/core/widgets/timer.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
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
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/my_account.dart';
import 'package:swa/features/home/presentation/screens/select_from_city/select_from_city.dart';
import 'package:swa/features/home/presentation/screens/select_to_city/select_to_city.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/widgets/carousel_widget.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_states.dart';
import 'package:swa/features/times_trips/presentation/screens/times_screen.dart';
import 'package:swa/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/location.dart';
import '../../../../../select_payment2/presentation/credit_card/presentation/navigation_helper.dart';
import '../../../../app_info/data/models/country_model.dart';
import 'more_tap/presentation/screens/Country_list.dart';

class MyHome extends StatefulWidget {
  bool? showNavBar;
  MyHome({super.key, this.showNavBar});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool isTabbed = false;

  int currentIndex = 0;
  List<CitiesStations>? _fromStations;
  List<CitiesStations>? _toStations;
  List<dynamic> tripList = [];
  List<dynamic> tripListBack = [];

  ///To be changed by selected station id
  int? _fromStationId;
  int? _toStationId;
  String _fromStationName = '';
  String _toStationName = '';
  String _fromCityName = '';
  String _toCityName = '';

  List<Country> countries = [];
  Country? dropdownvalue;

  DateTime? date;
  DateTime? selectedToGeorgianDate;
  JHijri? selectedToHijriDate;

  DateTime? selectedFromGeorgianDate;
  JHijri? selectedFromHijriDate;

  String selectedDatefrom =
      intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  String selectedDateto = intl.DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(Duration(days: 1)))
      .toString();

  bool ishijiri = false;

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
      log("Notification Count : $count");
    }
    isRefreshing = false;
    // PackageTermsCubit.get(context).getPackageTerms();// Reset the flag after refreshing.
  }

  static Future<void> initHMSPushNotifications(context) async {
    debugPrint("Started HMS Push Init");
    String token = '';
    // Enable auto-init
    await Push.setAutoInitEnabled(true);

    // Request a push token

    // Listen to token stream
    Push.getTokenStream.listen((String token) {
      debugPrint('HMS Token: $token');

      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Token:\n $token\n\n(from HMS init)"),
          ),
        ),
      );

      // You can save the token here if needed
    });

    // Listen for foreground push messages
    Push.onMessageReceivedStream.listen((RemoteMessage message) {
      print('Received a foreground message: ${message.data}');
    });

    Push.getToken("");

    void _onTokenEvent(
      String event,
    ) {
      // Requested tokens can be obtained here

      log("TokenEvent: " + token);
    }

    void _onTokenError(Object error) {}

    Future<void> initTokenStream() async {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final isHuawei = deviceInfo.manufacturer.toLowerCase().contains('huawei');

      if (isHuawei) {
        await Push.setAutoInitEnabled(true);
        Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
        Push.getToken("");
      }
    }

    initTokenStream();

    // Optional: Listen for notification opened or other events if you want
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();

      setState(() {});
    });
    super.initState();
    Ticketreservation.Seatsnumbers1.clear();
    Ticketreservation.Seatsnumbers2.clear();
    BlocProvider.of<GetAvailableCountriesCubit>(context)
        .getAvailableCountries();
    BlocProvider.of<PackagesBloc>(context).add(GetadsEvent());
    BlocProvider.of<PackagesBloc>(context).add(checkversionevent());
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    //initHMSPushNotifications(context);

    String _token = '';
    void _onTokenEvent(String event) {
      // Requested tokens can be obtained here
      setState(() {
        _token = event;
      });

      print("EVENT INITIATED");

      print("TokenEvent: " + _token);

      print("TokenEvent: " + _token);
    }

    void _onTokenError(Object error) {}

    Future<bool> isHuaweiDevice() async {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        return false;
      } else {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.manufacturer.toLowerCase() == 'huawei';
      }
    }

    Future<void> initTokenStream() async {
      final isHuawei = await isHuaweiDevice();

      if (isHuawei) {
        await Push.setAutoInitEnabled(true);
        if (!mounted) return;
        Push.getTokenStream.listen(
          _onTokenEvent,
          onError: _onTokenError,
        );

        Push.getToken("");
      }
    }

    initTokenStream();

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
                    print("A7a ${element.icon}");
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
              listener: (context, state) async {}),
          BlocListener(
            bloc: BlocProvider.of<GetAvailableCountriesCubit>(context),
            listener: (context, state) async {
              if (state is GetAvailableCountriesLoadedState) {
                log(state.countries.first.countryName.toString() + "))))))");
                await determinePosition(context, state.countries).then(
                  (value) async {
                    LocationPermission permission =
                        await Geolocator.checkPermission();

                    if (permission == LocationPermission.denied ||
                        permission == LocationPermission.deniedForever ||
                        permission == LocationPermission.unableToDetermine) {
                      print("A77med permission: ${permission}");
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
                    } else {
                      await Geolocator.checkPermission();
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
                            child: state.adsModel?.status == 'success'
                                ? CarouselWidget(items: [
                                    ...List<Widget>.generate(
                                      state.adsModel!.message!.length ?? 0,
                                      (index) => contentAdvertisment(
                                          state.adsModel!.message![index],
                                          sizeHeight),
                                    ),
                                  ])
                                : SizedBox(),
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
                                    InkWell(
                                      onTap: () {
                                        if (widget.showNavBar == true) {
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.initialRoute,
                                              (route) => false);
                                        }
                                      },
                                      child: Icon(
                                        Icons.arrow_back_rounded,
                                        color: AppColors.white,
                                        size: 25,
                                      ),
                                    ),
                                    5.horizontalSpace,
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
                                              NotificationsIcon(),
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
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            FontFamily.medium),
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: fontStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontFamily: FontFamily
                                                              .medium),
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
                                      style: fontStyle(
                                          color: tripTypeId == "1"
                                              ? AppColors.primaryColor
                                              : Color(0xffdddddd),
                                          fontSize: 18,
                                          fontFamily: FontFamily.medium,
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
                                      style: fontStyle(
                                          color: tripTypeId == "2"
                                              ? AppColors.primaryColor
                                              : Color(0xffdddddd),
                                          fontSize: 18,
                                          fontFamily: FontFamily.medium,
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
                                        String tostation;
                                        int? toid;

                                        toid = _toStationId;
                                        to = _toCityName;
                                        tostation = _toStationName;

                                        _toStationId = _fromStationId;
                                        _toStationName = _fromStationName;

                                        _toCityName = _fromCityName;

                                        _fromCityName = to;
                                        _fromStationName = tostation;

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
                                    style: fontStyle(
                                        fontFamily: FontFamily.medium,
                                        color: Colors.black,
                                        fontSize: 16),
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
                                          log(result.toString());
                                          setState(() {
                                            _fromStationId =
                                                result['_fromStationId'];
                                            _fromStationName =
                                                result['_fromStationName'];
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
                                        //           style: const fontStyle(
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
                                            hint: _fromStationName == ''
                                                ? LanguageClass.isEnglish
                                                    ? 'Select'
                                                    : 'تحديد'
                                                : '$_fromCityName - $_fromStationName')),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      LanguageClass.isEnglish ? "To" : "الي",
                                      style: fontStyle(
                                          fontFamily: FontFamily.medium,
                                          color: Colors.black,
                                          fontSize: 16),
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
                                            _toStationName =
                                                result['_toStationName'];
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
                                            hint: _toStationName == ''
                                                ? LanguageClass.isEnglish
                                                    ? 'Select'
                                                    : 'تحديد'
                                                : '$_toCityName - $_toStationName')),
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
                                        customdatepicker(
                                          context: context,
                                          hijiri: ishijiri,
                                          selectedGeorgianDate:
                                              selectedFromGeorgianDate,
                                          selectedHijriDate:
                                              selectedFromHijriDate,
                                          onchange: (hdate) {
                                            date = hdate.date;
                                            hdate.jhijri.fDisplay =
                                                DisplayFormat.MMDDYYYY;

                                            ishijiri
                                                ? selectedDatefrom =
                                                    hdate.jhijri.toString()
                                                : selectedDatefrom =
                                                    intl.DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(date!)
                                                        .toString();

                                            ishijiri
                                                ? selectedDateto =
                                                    hdate.jhijri.toString()
                                                : selectedDateto =
                                                    intl.DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(date!)
                                                        .toString();
                                            if (ishijiri) {
                                              selectedToHijriDate =
                                                  hdate.jhijri;
                                              selectedToGeorgianDate = null;
                                              selectedFromHijriDate =
                                                  hdate.jhijri;
                                              selectedFromGeorgianDate = null;
                                            } else {
                                              selectedToHijriDate = null;
                                              selectedToGeorgianDate =
                                                  hdate.date;
                                              selectedFromHijriDate = null;
                                              selectedFromGeorgianDate =
                                                  hdate.date;
                                            }

                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                        );
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
                                                    style: fontStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                              InkWell(
                                                child: Text(
                                                    "\n $selectedDatefrom",
                                                    textAlign: TextAlign.center,
                                                    style: fontStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize: 12)),
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
                                              customdatepicker(
                                                context: context,
                                                hijiri: ishijiri,
                                                selectedGeorgianDate:
                                                    selectedFromGeorgianDate,
                                                selectedHijriDate:
                                                    selectedFromHijriDate,
                                                onchange: (hdate) {
                                                  date = hdate.date;
                                                  hdate.jhijri.fDisplay =
                                                      DisplayFormat.MMDDYYYY;

                                                  ishijiri
                                                      ? selectedDatefrom = hdate
                                                          .jhijri
                                                          .toString()
                                                      : selectedDatefrom =
                                                          intl.DateFormat(
                                                                  'MM-dd-yyyy')
                                                              .format(date!)
                                                              .toString();

                                                  if (ishijiri) {
                                                    selectedFromHijriDate =
                                                        hdate.jhijri;
                                                    selectedFromGeorgianDate =
                                                        null;
                                                  } else {
                                                    selectedFromHijriDate =
                                                        null;
                                                    selectedFromGeorgianDate =
                                                        hdate.date;
                                                  }
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                              );
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
                                                      style: fontStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize:
                                                              (widget.showNavBar ==
                                                                      true)
                                                                  ? 10
                                                                  : 12),
                                                    )
                                                  ],
                                                ),
                                                InkWell(
                                                  child: Text(
                                                      "\n$selectedDatefrom",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: fontStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize:
                                                              (widget.showNavBar ==
                                                                      true)
                                                                  ? 12
                                                                  : 14)),
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
                                              customdatepicker(
                                                context: context,
                                                hijiri: ishijiri,
                                                selectedGeorgianDate:
                                                    selectedToGeorgianDate,
                                                selectedHijriDate:
                                                    selectedToHijriDate,
                                                onchange: (hdate) {
                                                  date = hdate.date;
                                                  hdate.jhijri.fDisplay =
                                                      DisplayFormat.MMDDYYYY;

                                                  ishijiri
                                                      ? selectedDateto = hdate
                                                          .jhijri
                                                          .toString()
                                                      : selectedDateto =
                                                          intl.DateFormat(
                                                                  'MM-dd-yyyy')
                                                              .format(date!)
                                                              .toString();

                                                  if (ishijiri) {
                                                    selectedToHijriDate =
                                                        hdate.jhijri;
                                                    selectedToGeorgianDate =
                                                        null;
                                                  } else {
                                                    selectedToHijriDate = null;
                                                    selectedToGeorgianDate =
                                                        hdate.date;
                                                  }
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                              );
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
                                                      style: fontStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize:
                                                              (widget.showNavBar ==
                                                                      true)
                                                                  ? 10
                                                                  : 12),
                                                    )
                                                  ],
                                                ),
                                                InkWell(
                                                  child: Text(
                                                      "\n$selectedDateto",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: fontStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize:
                                                              (widget.showNavBar ==
                                                                      true)
                                                                  ? 12
                                                                  : 14)),
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
                                        if (widget.showNavBar == true) {
                                          Navigator.pop(context, {
                                            "tripList": state.timesTripsResponse
                                                .message!.tripList,
                                            "tripTypeId": tripTypeId,
                                            "tripListBack": state
                                                    .timesTripsResponse
                                                    .message!
                                                    .tripListBack ??
                                                [],
                                            "fromTrip": _fromCityName,
                                            "toTrip": _toCityName,
                                            "dateTrip": selectedDatefrom,
                                            "numberOfAdults": "1",
                                          });
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                settings: RouteSettings(
                                                    name: 'TimesScreen'),
                                                builder: (context) {
                                                  return TimesScreen(
                                                    tripList: state
                                                        .timesTripsResponse
                                                        .message!
                                                        .tripList,
                                                    tripTypeId: tripTypeId,
                                                    tripListBack: state
                                                            .timesTripsResponse
                                                            .message!
                                                            .tripListBack ??
                                                        [],
                                                    fromTrip: _fromCityName,
                                                    toTrip: _toCityName,
                                                    dateTrip: selectedDatefrom,
                                                    numberOfAdults: "1",
                                                    tripType:
                                                        tripTypeId.toString(),
                                                    fromStationID:
                                                        _fromStationId
                                                            .toString(),
                                                    toStationID:
                                                        _toStationId.toString(),
                                                    dateGo: selectedDatefrom
                                                        .toString(),
                                                    dateBack: selectedDateto
                                                        .toString(),
                                                  );
                                                },
                                              )).then((value) {
                                            Reservationtimer.stoptimer();

                                            Ticketreservation.Seatsnumbers1
                                                .clear();
                                            Ticketreservation.Seatsnumbers2
                                                .clear();
                                          });
                                        }
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
                                            "  ${selectedDatefrom.toString()}  ${selectedDateto.toString()}");
                                        CacheHelper.setDataToSharedPref(
                                            key: 'fromStationId',
                                            value: _fromStationId.toString());
                                        CacheHelper.setDataToSharedPref(
                                            key: 'toStationId',
                                            value: _toStationId.toString());
                                        CacheHelper.setDataToSharedPref(
                                            key: 'selectedDayTo',
                                            value: selectedDateto.toString());
                                        CacheHelper.setDataToSharedPref(
                                            key: 'selectedDayFrom',
                                            value: selectedDatefrom.toString());
                                        print("===}======");

                                        UmraDetails.dateTypeID =
                                            ishijiri ? 112 : 113;
                                        BlocProvider.of<TimesTripsCubit>(
                                                context)
                                            .getTimes(
                                          tripType: tripTypeId.toString(),
                                          fromStationID:
                                              _fromStationId.toString(),
                                          toStationID: _toStationId.toString(),
                                          dateGo: selectedDatefrom.toString(),
                                          dateBack: selectedDateto.toString(),
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
                                          style: fontStyle(
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
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: (widget.showNavBar == true)
          ? SizedBox.shrink()
          : UmraDetails.isbusforumra
              ? SizedBox()
              : Navigationbottombar(
                  currentIndex: 0,
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
      // setState(() {
      //   if (selectedDay == selectedDayFrom) {
      //     selectedDayFrom = newSelectedDay;
      //   } else if (selectedDay == selectedDayTo) {
      //     selectedDayTo = newSelectedDay;
      //   }
      // });
    }
  }

  Future customdatepicker({
    required BuildContext context,
    required bool hijiri,
    DateTime? selectedGeorgianDate,
    JHijri? selectedHijriDate,
    required Function(JPickerValue date) onchange,
  }) async {
    return await showGlobalDatePicker(
      context: context,
      headerTitle: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          // color: Colors.white,
        ),
        child: InkWell(
            onTap: () {
              Navigator.pop(context);
              ishijiri = !ishijiri;
              selectedGeorgianDate = null;
              selectedHijriDate = null;
              selectedFromGeorgianDate = null;
              selectedFromHijriDate = null;
              selectedToGeorgianDate = null;
              selectedToHijriDate = null;
              selectedDatefrom = ishijiri
                  ? JHijri(
                          fDisplay: DisplayFormat.MMDDYYYY,
                          fDate: DateTime.now())
                      .toString()
                  : intl.DateFormat('yyyy-MM-dd')
                      .format(DateTime.now())
                      .toString();
              selectedDateto = ishijiri
                  ? JHijri(
                          fDisplay: DisplayFormat.MMDDYYYY,
                          fDate: DateTime.now().add(Duration(days: 1)))
                      .toString()
                  : intl.DateFormat('yyyy-MM-dd')
                      .format(DateTime.now().add(Duration(days: 1)))
                      .toString();

              customdatepicker(
                selectedGeorgianDate: selectedGeorgianDate,
                selectedHijriDate: selectedHijriDate,
                context: context,
                hijiri: ishijiri,
                onchange: onchange,
              );
              setState(() {});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  hijiri
                      ? LanguageClass.isEnglish
                          ? 'Hijri'
                          : 'هجري'
                      : LanguageClass.isEnglish
                          ? 'Gregorian'
                          : "ميلادي",
                  style: fontStyle(
                      height: 1.2,
                      fontFamily: FontFamily.medium,
                      fontSize: 14.sp,
                      color: AppColors.white
                      // color: AppColors.blackColor
                      ),
                ),
                5.horizontalSpace,
                Icon(
                  Icons.change_circle_rounded,
                  color: AppColors.white,
                  // color: AppColors.primaryColor,
                  size: 20,
                )
              ],
            )),
      ),
      selectedDate: JDateModel(
        jhijri: hijiri ? (selectedHijriDate ?? JHijri.now()) : null,
        dateTime: !hijiri
            ? (selectedGeorgianDate ??
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day))
            : null,
      ),
      pickerMode: DatePickerMode.day,
      pickerTheme: Theme.of(context).copyWith(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryColor,
          onPrimary: Colors.white,
          onSurface: Colors.black,
          surface: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          labelLarge: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryColor, // Button text color
          ),
        ),
      ),
      startDate: JDateModel(
          dateTime: DateTime.now().subtract(Duration(days: ishijiri ? 1 : 0))),
      textDirection: TextDirection.ltr,
      buttons: Container(),
      locale: LanguageClass.isEnglish ? Locale("en", "US") : Locale("ar", ""),
      pickerType: hijiri ? PickerType.JHijri : PickerType.JNormal,
      onChange: onchange,
      primaryColor: AppColors.primaryColor,
      calendarTextColor: Colors.black,
      backgroundColor: AppColors.greyLight,
      // backgroundColor: Colors.white,
      borderRadius: const Radius.circular(0),
      buttonTextColor: Colors.white,
    );
  }
}
