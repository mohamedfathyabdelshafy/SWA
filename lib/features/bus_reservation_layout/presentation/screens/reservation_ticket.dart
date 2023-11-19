import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/text_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/icon_back.dart';

class ReservationTicket extends StatefulWidget {
  const ReservationTicket({super.key});

  @override
  State<ReservationTicket> createState() => _ReservationTicketState();
}

class _ReservationTicketState extends State<ReservationTicket> {
  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar:  AppBar(
        leading:iconBack(context),
        backgroundColor: Colors.black,
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Text(
              "Ticket",
              style: TextStyle(color: AppColors.white,fontSize: 34,fontFamily:"regular"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              height: sizeHeight * 0.5 ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                border: Border.all(color: Colors.white)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Departure on",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "regular",
                          fontSize: 12
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: Row(
                        children: [
                          Text("#55454",
                          style: TextStyle(
                            fontFamily: "regular",
                            fontSize: 15,
                            color: Colors.white
                          ),
                          ),
                          SizedBox(
                            width: sizeWidth * 0.05,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: sizeWidth *0.45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.primaryColor
                            ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              "assets/images/Icon awesome-bus-alt.svg"
                          ),
                          SizedBox(
                            width: sizeWidth * 0.05,
                          ),
                         const Text(
                            "05:01",
                            style:  TextStyle(
                              fontFamily: "regular",
                              fontSize: 30,
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "regular"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Container(
                            height: sizeHeight * 0.018,
                            width: sizeHeight * 0.018,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white)
                            ),
                          ),
                          SizedBox(
                            width: sizeWidth * 0.02,
                          ),
                          TextWidget(text: "From",fontSize: 15,)
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
