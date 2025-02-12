import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:badges/badges.dart' as badges;

import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/Enter_trip_data.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/packages_list_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/home/data/models/Notifications_model.dart';
import 'package:swa/features/home/presentation/screens/Notification/Notification_respotary.dart';
import 'package:swa/features/home/presentation/screens/Notification/Notification_screen.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/my_account.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';

class SelectUmratypeScreen extends StatefulWidget {
  const SelectUmratypeScreen({super.key});

  @override
  State<SelectUmratypeScreen> createState() => _SelectUmratypeScreenState();
}

class _SelectUmratypeScreenState extends State<SelectUmratypeScreen> {
  final UmraBloc _umraBloc = UmraBloc();
  User? _user;

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

  void updateNotificationCount(int newCount) {
    setState(() {
      count = newCount;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _umraBloc.add(TripUmraTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
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
                  BlocProvider.of<PackagesBloc>(context)
                      .add(GetpopupadsEvent());
                }
              },
            )
          ],
          child: BlocBuilder(
              bloc: _umraBloc,
              builder: (context, UmraState state) {
                if (state.isloading == true) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.umragold,
                    ),
                  );
                } else {
                  return SafeArea(
                    bottom: false,
                    child: Container(
                      child: Column(
                        children: [
                          10.verticalSpace,
                          Container(
                            padding: const EdgeInsets.only(left: 27, right: 27),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: LanguageClass.isEnglish
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.initialRoute,
                                          (route) => false);
                                    },
                                    child: Icon(
                                      Icons.arrow_back_rounded,
                                      color: AppColors.umragold,
                                      size: 25,
                                    ),
                                  ),
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
                                                    color: AppColors.umragold,
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
                                                              style: fontStyle(
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
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
                                                color: AppColors.umragold,
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
                                                        color: Colors.white,
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
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            FontFamily.regular),
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
                                                color: AppColors.umragold,
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
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontFamily: FontFamily
                                                              .regular),
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
                          Expanded(
                              child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 80.h,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child:
                                      Image.asset('assets/images/swaumra.png'),
                                ),
                                Spacer(),
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.asset('assets/images/umrah.png'),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Text(
                                  'Made Effortlessly Easy',
                                  style: fontStyle(
                                      fontFamily: FontFamily.regular,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffA3A3A3)),
                                )
                              ],
                            ),
                          )),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  for (int i = 0;
                                      i <
                                          state.tripUmramodel!.message!.list!
                                              .length;
                                      i++)
                                    state.tripUmramodel!.message!.list![i]
                                            .isActive!
                                        ? Container(
                                            height: 70,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 33.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(41),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Color(0xff707070)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child: InkWell(
                                                  onTap: () {
                                                    UmraDetails
                                                            .tripTypeUmrahID =
                                                        state
                                                            .tripUmramodel!
                                                            .message!
                                                            .list![i]
                                                            .tripUmraTypeId!;

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                TripdataScreen(
                                                                  triptype: state
                                                                      .tripUmramodel!
                                                                      .message!
                                                                      .list![i]
                                                                      .name!,
                                                                  typeid: state
                                                                      .tripUmramodel!
                                                                      .message!
                                                                      .list![i]
                                                                      .tripUmraTypeId!,
                                                                )));
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      state
                                                          .tripUmramodel!
                                                          .message!
                                                          .list![i]
                                                          .name!,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      textDirection:
                                                          LanguageClass.isEnglish
                                                              ? TextDirection
                                                                  .ltr
                                                              : TextDirection
                                                                  .rtl,
                                                      style: fontStyle(
                                                          fontFamily:
                                                              FontFamily.bold,
                                                          fontSize: 24,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                )),
                                                Tooltip(
                                                  triggerMode:
                                                      TooltipTriggerMode.tap,
                                                  message: state
                                                      .tripUmramodel!
                                                      .message!
                                                      .list![i]
                                                      .description,
                                                  verticalOffset: -70,
                                                  textStyle: fontStyle(
                                                    fontFamily: FontFamily.bold,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign:
                                                      LanguageClass.isEnglish
                                                          ? TextAlign.left
                                                          : TextAlign.right,
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.24),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffECB95A),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              23)),
                                                  child: Icon(
                                                    Icons.info_outline_rounded,
                                                    color: Color(0xffA5A5A5),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : SizedBox()
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              }),
        ),
        bottomNavigationBar: Navigationbottombar(
          currentIndex: 0,
        ));
  }
}
