import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/icon_back.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/Container_Widget.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/text_widget.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Response_ticket_history_Model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/repo/ticket_repo.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/main.dart';

class TicketHistory extends StatefulWidget {
  TicketHistory({super.key, required this.user});
  User? user;
  @override
  State<TicketHistory> createState() => _TicketHistoryState();
}

class _TicketHistoryState extends State<TicketHistory> {
  ResponseTicketHistoryModel? responseTicketHistoryModel;
  TicketRepo ticketRepo = TicketRepo(sl());
  @override
  void initState() {
    get();
    super.initState();

    //   Future.delayed(const Duration(seconds: 0)).then((_) async {
    //     BlocProvider.of<TicketCubit>(context).getTicketHistory(3);
    //   });
  }

  get() async {
    responseTicketHistoryModel =
        await ticketRepo.getTicketHistory(customerId: widget.user?.customerId??0);
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: sizeHeight * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: sizeHeight * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Text(
                LanguageClass.isEnglish?"Your Tickets":"تذاكارك",
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 34,
                    fontFamily: "regular"),
              ),
            ),
            responseTicketHistoryModel?.message != null?Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: responseTicketHistoryModel?.message?.length,
                  itemBuilder: (context, index) {
                    print(
                        "responseTicketHistoryModel?.message?.length${responseTicketHistoryModel?.message?.length}");
                    final ticket = responseTicketHistoryModel?.message![index];
                    return SizedBox(
                      height: sizeHeight * 0.8,
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Container(
                                    height: sizeHeight * 0.63,
                                    width: sizeWidth * 0.8,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
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
                                                horizontal: 15, vertical: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "#${ticket?.tripNumber?.toString()}" ??
                                                      "",
                                                  style: TextStyle(
                                                      fontFamily: "regular",
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  width: sizeWidth * 0.05,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  width: sizeWidth * 0.45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: AppColors
                                                          .primaryColor),
                                                  child: Text(
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
                                                Text(
                                                  DateFormat('d/M/y, hh:mm a')
                                                      .format(ticket
                                                              ?.reservationDate ??
                                                          DateTime.now()),
                                                  style: TextStyle(
                                                      fontFamily: "regular",
                                                      fontSize: 15,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: sizeHeight * 0.018,
                                                  width: sizeHeight * 0.018,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors.white)),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: TextWidget(
                                                      text: ticket?.from ?? "",
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18),
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12),
                                                  child: TextWidget(
                                                    text: "",
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              children: [
                                                ContainerWidget(
                                                  color: AppColors.primaryColor,
                                                  height: 0.025,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12),
                                                  child: TextWidget(
                                                    text: "To",
                                                    fontSize: 15,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: TextWidget(
                                                  text: ticket?.to ?? "",
                                                  fontSize: 18,
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            height: sizeHeight * 0.05,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 0,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          child: Stack(
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/images/unavailable_seats.svg",
                                                                color: AppColors
                                                                    .primaryColor,
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
                                                  ("EGP ${ticket?.price ?? 0}")
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ):Container(),
          ],
        ),
      ),
    );
  }
}
