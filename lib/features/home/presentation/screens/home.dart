import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/account.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/screen/ticket_history.dart';
import 'package:swa/features/payment/wallet/presentation/screens/my_wallet.dart';
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
  DateTime selectedDayTo = DateTime.now().add(Duration(days: 1));

  ///To be changed by selected station id

  ///Getting if user is logged in or not
  User? _user;
 String tripTypeId = "1";
 List <dynamic> tripListBack = [];
 List <Widget> screens = [
   MyHome(),
   TicketHistory(),
   AccountTap(),
   MyCredit(),
 ];
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
    double sizeWidth = context.width;

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: SizedBox(
        height: sizeHeight * 0.1,
        child: Theme(
          data:Theme.of(context).copyWith(canvasColor: AppColors.darkPurple,),
          child: BottomNavigationBar(
            onTap: (index){
              setState(() {
                currentIndex =index;
              });
            },
            currentIndex: currentIndex,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedItemColor:AppColors.primaryColor, // Color for the selected tab icon and label
            unselectedItemColor: AppColors.darkGrey,
            selectedLabelStyle: TextStyle(
                color: AppColors.primaryColor
            ),
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/Icon awesome-bus.svg",
                    color:currentIndex == 0?AppColors.primaryColor:AppColors.darkGrey ,
                  ),
                  label: "Book Now"
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/Icon awesome-ticket-alt.svg",
                    color:currentIndex == 1 ?AppColors.primaryColor:AppColors.darkGrey ,
                  ),

                  label: "Ticket"
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/Icon material-person-outline.svg",
                  color:currentIndex == 2?AppColors.primaryColor:AppColors.darkGrey ,
                ),
                label: "Account",

              ),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/images/Group 175.svg",
                      color:currentIndex == 3?AppColors.primaryColor:AppColors.darkGrey ,
                    ),
                  ),
                  label: "More"
              ),
            ],
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
