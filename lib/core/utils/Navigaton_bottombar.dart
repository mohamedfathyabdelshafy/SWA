import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/Select_type.dart';
import 'package:swa/features/Swa_umra/Screens/Umra_booked_ticket.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/more_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/screen/ticket_history.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/payment/wallet/presentation/screens/my_wallet.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';

class Navigationbottombar extends StatefulWidget {
  int currentIndex;
  Navigationbottombar({super.key, required this.currentIndex});

  @override
  State<Navigationbottombar> createState() => _NavigationbottombarState();
}

class _NavigationbottombarState extends State<Navigationbottombar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(41),
              color: Routes.isomra ? AppColors.umragold : Color(0xffFF5D4B)),
          transformAlignment: Alignment.center,
          child: SalomonBottomBar(
            duration: Duration(microseconds: 200),
            currentIndex: widget.currentIndex,
            selectedColorOpacity: 1,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            itemPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            onTap: (i) {
              if (widget.currentIndex != i) {
                setState(() => widget.currentIndex = i);

                switch (i) {
                  case 0:
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<LoginCubit>(
                                    create: (context) => sl<LoginCubit>(),
                                  ),
                                  BlocProvider<PackagesBloc>(
                                    create: (context) => PackagesBloc(),
                                  ),
                                  BlocProvider<FawryReservation>(
                                    create: (context) => sl<FawryReservation>(),
                                  ),
                                  BlocProvider<GetAvailableCountriesCubit>(
                                    create: (context) =>
                                        sl<GetAvailableCountriesCubit>(),
                                  ),
                                  BlocProvider<HomeCubit>(
                                    create: (context) => sl<HomeCubit>(),
                                  ),
                                  BlocProvider<TimesTripsCubit>(
                                      create: (context) =>
                                          sl<TimesTripsCubit>()),
                                  BlocProvider<TicketCubit>(
                                      create: (context) => sl<TicketCubit>()),
                                ],
                                child: Routes.isomra
                                    ? SelectUmratypeScreen()
                                    : MyHome(),
                              )),
                      (route) => false,
                    );
                    break;

                  case 1:
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<LoginCubit>(
                                    create: (context) => sl<LoginCubit>(),
                                  ),
                                  BlocProvider<PackagesBloc>(
                                    create: (context) => PackagesBloc(),
                                  ),
                                  BlocProvider<FawryReservation>(
                                    create: (context) => sl<FawryReservation>(),
                                  ),
                                  BlocProvider<GetAvailableCountriesCubit>(
                                    create: (context) =>
                                        sl<GetAvailableCountriesCubit>(),
                                  ),
                                  BlocProvider<HomeCubit>(
                                    create: (context) => sl<HomeCubit>(),
                                  ),
                                  BlocProvider<TimesTripsCubit>(
                                      create: (context) =>
                                          sl<TimesTripsCubit>()),
                                  BlocProvider<TicketCubit>(
                                      create: (context) => sl<TicketCubit>()),
                                ],
                                child: Routes.isomra
                                    ? UmraBookedScreen()
                                    : TicketHistory(user: Routes.user),
                              )),
                      (route) => false,
                    );

                    break;

                  case 2:
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyCredit(user: Routes.user),
                      ),
                      (route) => false,
                    );
                    break;

                  case 3:
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<LoginCubit>(
                                    create: (context) => sl<LoginCubit>(),
                                  ),
                                  BlocProvider<PackagesBloc>(
                                    create: (context) => PackagesBloc(),
                                  ),
                                  BlocProvider<FawryReservation>(
                                    create: (context) => sl<FawryReservation>(),
                                  ),
                                  BlocProvider<GetAvailableCountriesCubit>(
                                    create: (context) =>
                                        sl<GetAvailableCountriesCubit>(),
                                  ),
                                  BlocProvider<HomeCubit>(
                                    create: (context) => sl<HomeCubit>(),
                                  ),
                                  BlocProvider<TimesTripsCubit>(
                                      create: (context) =>
                                          sl<TimesTripsCubit>()),
                                  BlocProvider<TicketCubit>(
                                      create: (context) => sl<TicketCubit>()),
                                ],
                                child: MoreScreen(),
                              )),
                      (route) => false,
                    );

                    break;

                  default:
                }
              }
            },
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  "assets/images/Icon awesome-bus.svg",
                  color: widget.currentIndex == 0
                      ? Routes.isomra
                          ? AppColors.umragold
                          : AppColors.primaryColor
                      : AppColors.white,
                ),
                title: Text(
                  LanguageClass.isEnglish ? "Book Now" : "حجز الان",
                  style: fontStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: FontFamily.bold),
                ),
                selectedColor: Colors.white,
              ),

              /// Likes
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  "assets/images/Icon awesome-ticket-alt.svg",
                  color: widget.currentIndex == 1
                      ? Routes.isomra
                          ? AppColors.umragold
                          : AppColors.primaryColor
                      : AppColors.white,
                ),
                title: Text(
                  LanguageClass.isEnglish ? "Ticket" : "تذكرة",
                  style: fontStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: FontFamily.bold),
                ),
                selectedColor: Colors.white,
              ),

              /// Search
              SalomonBottomBarItem(
                icon: Icon(
                  Icons.wallet,
                  color: widget.currentIndex == 2
                      ? Routes.isomra
                          ? AppColors.umragold
                          : AppColors.primaryColor
                      : AppColors.white,
                ),
                title: Text(
                  LanguageClass.isEnglish ? "My wallet" : "محفظتي",
                  style: fontStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: FontFamily.bold),
                ),
                selectedColor: Colors.white,
              ),

              /// Profile
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  "assets/images/Group 175.svg",
                  color: widget.currentIndex == 3
                      ? Routes.isomra
                          ? AppColors.umragold
                          : AppColors.primaryColor
                      : AppColors.white,
                ),
                title: Text(
                  LanguageClass.isEnglish ? "More" : "المزيد",
                  style: fontStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: FontFamily.bold),
                ),
                selectedColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
