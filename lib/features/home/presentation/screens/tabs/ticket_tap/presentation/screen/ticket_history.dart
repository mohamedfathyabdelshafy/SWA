import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/icon_back.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/Container_Widget.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/text_widget.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Response_ticket_history_Model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/repo/ticket_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/main.dart';

class TicketHistory extends StatefulWidget {
  TicketHistory({super.key, this.user});
  User? user;
  @override
  State<TicketHistory> createState() => _TicketHistoryState();
}

class _TicketHistoryState extends State<TicketHistory> {
  ResponseTicketHistoryModel? responseTicketHistoryModel;
  TicketRepo ticketRepo = TicketRepo(sl());
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<TicketCubit>(context).getTicketHistory(3);
    });
  }

  get() {
    ticketRepo.getTicketHistory(customerId: 3).then((value) async {
      responseTicketHistoryModel = await value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: iconBack(context),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Text(
              "Ticket",
              style: TextStyle(
                  color: AppColors.white, fontSize: 34, fontFamily: "regular"),
            ),
          ),
          SizedBox(
            height: sizeHeight * 0.7,
            child: SingleChildScrollView(
              // child: BlocListener(
              //   bloc: BlocProvider.of<LoginCubit>(context),
              //   listener: (context, state) {
              //     if (state is UserLoginLoadedState) {
              //       _user = state.userResponse.user;
              //     }
              //   },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: sizeHeight * 0.8,
                      width: sizeWidth * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Departure on",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "regular",
                                    fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  const Text(
                                    "#55454",
                                    style: TextStyle(
                                        fontFamily: "regular",
                                        fontSize: 15,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: sizeWidth * 0.05,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width: sizeWidth * 0.45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColors.primaryColor),
                                    child: const Text(
                                      "Elite Business Class",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: "regular",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/images/Icon awesome-bus-alt.svg"),
                                  SizedBox(
                                    width: sizeWidth * 0.05,
                                  ),
                                  const Text(
                                    "05:01",
                                    style: TextStyle(
                                        fontFamily: "regular",
                                        fontSize: 30,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: sizeWidth * 0.9,
                              child: Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              //  child:const  Text(
                              //   "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 20,
                              //     fontFamily: "regular"
                              //   ),
                              // ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Container(
                                    height: sizeHeight * 0.018,
                                    width: sizeHeight * 0.018,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        border:
                                            Border.all(color: Colors.white)),
                                  ),
                                  SizedBox(
                                    width: sizeWidth * 0.02,
                                  ),
                                  TextWidget(
                                    text: "From",
                                    fontSize: 15,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  ContainerWidget(
                                    color: Colors.transparent,
                                    height: 0.01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: TextWidget(
                                      text: "",
                                      fontSize: 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  ContainerWidget(
                                    color: AppColors.primaryColor,
                                    height: 0.013,
                                  ),
                                  SizedBox(
                                    width: sizeWidth * 0.005,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextWidget(
                                      text: "Hurghada, Al Ahyaa",
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: sizeHeight * 0.015,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  ContainerWidget(
                                    color: AppColors.primaryColor,
                                    height: 0.013,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: sizeHeight * 0.015,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  ContainerWidget(
                                    color: AppColors.primaryColor,
                                    height: 0.025,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextWidget(
                                      text: "To",
                                      fontSize: 15,
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: TextWidget(
                                    text: "",
                                    fontSize: 30,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 42),
                                  child: TextWidget(
                                    text: "Cairo, Tahrir",
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: sizeHeight * 0.05,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 0,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Stack(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/unavailable_seats.svg",
                                                  color: AppColors.primaryColor,
                                                )
                                              ],
                                            ),
                                          ),
                                          //SizedBox(width: 5,)
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              width: sizeWidth * 0.9,
                              child: const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              //  child:const  Text(
                              //   "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 20,
                              //     fontFamily: "regular"
                              //   ),
                              // ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    ("EGP").toString(),
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontFamily: "bold",
                                        fontSize: 25),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight * 0.05,
                  ),
                  // widget.tripTypeId != null && widget.tripTypeId == "2"  ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: sizeHeight * 0.65,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Departure on",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "regular",
                                    fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  const Text(
                                    "#55454",
                                    style: TextStyle(
                                        fontFamily: "regular",
                                        fontSize: 15,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: sizeWidth * 0.05,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width: sizeWidth * 0.45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColors.primaryColor),
                                    child: const Text(
                                      "Elite Business Class",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: "regular",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/images/Icon awesome-bus-alt.svg"),
                                  SizedBox(
                                    width: sizeWidth * 0.05,
                                  ),
                                  const Text(
                                    "05:01",
                                    style: TextStyle(
                                        fontFamily: "regular",
                                        fontSize: 30,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: sizeWidth * 0.9,
                              child: const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              //  child:const  Text(
                              //   "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 20,
                              //     fontFamily: "regular"
                              //   ),
                              // ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Container(
                                    height: sizeHeight * 0.018,
                                    width: sizeHeight * 0.018,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        border:
                                            Border.all(color: Colors.white)),
                                  ),
                                  SizedBox(
                                    width: sizeWidth * 0.02,
                                  ),
                                  TextWidget(
                                    text: "To",
                                    fontSize: 15,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  ContainerWidget(
                                    color: Colors.transparent,
                                    height: 0.01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: TextWidget(
                                      text: "",
                                      fontSize: 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  ContainerWidget(
                                    color: AppColors.primaryColor,
                                    height: 0.013,
                                  ),
                                  SizedBox(
                                    width: sizeWidth * 0.005,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextWidget(
                                      text: "Hurghada, Al Ahyaa",
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: sizeHeight * 0.015,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  ContainerWidget(
                                    color: AppColors.primaryColor,
                                    height: 0.013,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: sizeHeight * 0.015,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  ContainerWidget(
                                    color: AppColors.primaryColor,
                                    height: 0.025,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextWidget(
                                      text: "From",
                                      fontSize: 15,
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: TextWidget(
                                    text: "",
                                    fontSize: 30,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 42),
                                  child: TextWidget(
                                    text: "Cairo, Tahrir",
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: sizeHeight * 0.05,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 0,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Stack(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/unavailable_seats.svg",
                                                  color: AppColors.primaryColor,
                                                )
                                              ],
                                            ),
                                          ),
                                          //SizedBox(width: 5,)
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              width: sizeWidth * 0.9,
                              child: const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              //  child:const  Text(
                              //   "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 20,
                              //     fontFamily: "regular"
                              //   ),
                              // ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    ("EGP").toString(),
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontFamily: "bold",
                                        fontSize: 25),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                  // :SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
