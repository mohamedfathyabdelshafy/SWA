import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/more_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/screen/ticket_history.dart';
import 'package:swa/features/payment/wallet/presentation/screens/my_wallet.dart';
import 'package:swa/features/sign_in/data/data_sources/login_local_data_source.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTabbed = false;
  int currentIndex = 0;
  DateTime selectedDayFrom = DateTime.now();
  DateTime selectedDayTo = DateTime.now().add(const Duration(days: 1));

  ///To be changed by selected station id

  ///Getting if user is logged in or not
  User? _user;
  String tripTypeId = "1";
  List<dynamic> tripListBack = [];

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    List<Widget> screens = [
      const MyHome(),
      TicketHistory(user: _user),
      MyCredit(user: _user),
      const MoreScreen(),
    ];
    return BlocListener(
        bloc: BlocProvider.of<LoginCubit>(context),
        listener: (context, state) {
          if (state is UserLoginLoadedState) {
            _user = state.userResponse.user;

            Routes.customerid = state.userResponse.user!.customerId;
          }
        },
        child: Scaffold(
          body: screens[currentIndex],
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(41),
                    color: Color(0xffFF5D4B)),
                child: SalomonBottomBar(
                  currentIndex: currentIndex,
                  selectedColorOpacity: 1,
                  unselectedItemColor: Colors.white,
                  onTap: (i) => setState(() => currentIndex = i),
                  items: [
                    /// Home
                    SalomonBottomBarItem(
                      icon: SvgPicture.asset(
                        "assets/images/Icon awesome-bus.svg",
                        color: currentIndex == 0
                            ? AppColors.primaryColor
                            : AppColors.white,
                      ),
                      title: Text(
                        LanguageClass.isEnglish ? "Book Now" : "حجز الان",
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                      selectedColor: Colors.white,
                    ),

                    /// Likes
                    SalomonBottomBarItem(
                      icon: SvgPicture.asset(
                        "assets/images/Icon awesome-ticket-alt.svg",
                        color: currentIndex == 1
                            ? AppColors.primaryColor
                            : AppColors.white,
                      ),
                      title: Text(
                        LanguageClass.isEnglish ? "Ticket" : "تذكرة",
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                      selectedColor: Colors.white,
                    ),

                    /// Search
                    SalomonBottomBarItem(
                      icon: Icon(
                        Icons.wallet,
                        color: currentIndex == 2
                            ? AppColors.primaryColor
                            : AppColors.white,
                      ),
                      title: Text(
                        LanguageClass.isEnglish ? "My wallet" : "محفظتي",
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                      selectedColor: Colors.white,
                    ),

                    /// Profile
                    SalomonBottomBarItem(
                      icon: SvgPicture.asset(
                        "assets/images/Group 175.svg",
                        color: currentIndex == 3
                            ? AppColors.primaryColor
                            : AppColors.white,
                      ),
                      title: Text(
                        LanguageClass.isEnglish ? "More" : "المزيد",
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                      selectedColor: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
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
