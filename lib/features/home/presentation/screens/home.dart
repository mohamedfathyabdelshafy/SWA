// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// import 'package:swa/config/routes/app_routes.dart';
// import 'package:swa/core/local_cache_helper.dart';
// import 'package:swa/core/utils/app_colors.dart';
// import 'package:swa/core/utils/language.dart';
// import 'package:swa/core/utils/location.dart';
// import 'package:swa/features/Swa_umra/Screens/Select_type.dart';
// import 'package:swa/features/Swa_umra/Screens/Umra_booked_ticket.dart';
// import 'package:swa/features/app_info/domain/entities/country.dart';
// import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
// import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
// import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/more_screen.dart';
// import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
// import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/screen/ticket_history.dart';
// import 'package:swa/features/payment/wallet/presentation/screens/my_wallet.dart';
// import 'package:swa/features/sign_in/domain/entities/user.dart';
// import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

// class HomeScreen extends StatefulWidget {
//   bool isumra;
//   HomeScreen({super.key, required this.isumra});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int currentIndex = 0;

//   ///To be changed by selected station id

//   ///Getting if user is logged in or not
//   User? _user;
//   String tripTypeId = "1";
//   List<dynamic> tripListBack = [];

//   @override
//   void initState() {
//     BlocProvider.of<LoginCubit>(context).getUserData();
//     super.initState();
//     BlocProvider.of<GetAvailableCountriesCubit>(context)
//         .getAvailableCountries();

//     setState(() {});
//     super.initState();

//     BlocProvider.of<PackagesBloc>(context).add(checkversionevent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> screens = [
//       widget.isumra ? const SelectUmratypeScreen() : MyHome(),
//       widget.isumra ? UmraBookedScreen() : TicketHistory(user: _user),
//       MyCredit(user: _user),
//       const MoreScreen(),
//     ];
//     return Scaffold(
//       body: screens[currentIndex],
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             alignment: Alignment.bottomCenter,
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(41),
//                 color: widget.isumra ? AppColors.umragold : Color(0xffFF5D4B)),
//             padding: EdgeInsets.zero,
//             child: SalomonBottomBar(
//               duration: Duration(microseconds: 200),
//               currentIndex: currentIndex,
//               selectedColorOpacity: 1,
//               unselectedItemColor: Colors.white,
//               onTap: (i) => setState(() => currentIndex = i),
//               items: [
//                 /// Home
//                 SalomonBottomBarItem(
//                   icon: SvgPicture.asset(
//                     "assets/images/Icon awesome-bus.svg",
//                     color: currentIndex == 0
//                         ? widget.isumra
//                             ? AppColors.umragold
//                             : AppColors.primaryColor
//                         : AppColors.white,
//                   ),
//                   title: Text(
//                     LanguageClass.isEnglish ? "Book Now" : "حجز الان",
//                     style: fontStyle(color: Colors.black, fontSize: 13),
//                   ),
//                   selectedColor: Colors.white,
//                 ),

//                 /// Likes
//                 SalomonBottomBarItem(
//                   icon: SvgPicture.asset(
//                     "assets/images/Icon awesome-ticket-alt.svg",
//                     color: currentIndex == 1
//                         ? widget.isumra
//                             ? AppColors.umragold
//                             : AppColors.primaryColor
//                         : AppColors.white,
//                   ),
//                   title: Text(
//                     LanguageClass.isEnglish ? "Ticket" : "تذكرة",
//                     style: fontStyle(color: Colors.black, fontSize: 13),
//                   ),
//                   selectedColor: Colors.white,
//                 ),

//                 /// Search
//                 SalomonBottomBarItem(
//                   icon: Icon(
//                     Icons.wallet,
//                     color: currentIndex == 2
//                         ? widget.isumra
//                             ? AppColors.umragold
//                             : AppColors.primaryColor
//                         : AppColors.white,
//                   ),
//                   title: Text(
//                     LanguageClass.isEnglish ? "My wallet" : "محفظتي",
//                     style: fontStyle(color: Colors.black, fontSize: 13),
//                   ),
//                   selectedColor: Colors.white,
//                 ),

//                 /// Profile
//                 SalomonBottomBarItem(
//                   icon: SvgPicture.asset(
//                     "assets/images/Group 175.svg",
//                     color: currentIndex == 3
//                         ? widget.isumra
//                             ? AppColors.umragold
//                             : AppColors.primaryColor
//                         : AppColors.white,
//                   ),
//                   title: Text(
//                     LanguageClass.isEnglish ? "More" : "المزيد",
//                     style: fontStyle(color: Colors.black, fontSize: 13),
//                   ),
//                   selectedColor: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           )
//         ],
//       ),
//     );
//   }
// }
