import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/Container_Widget.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/text_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/icon_back.dart';
import '../PLOH/bus_layout_reservation_cubit.dart';
import '../PLOH/bus_layout_reservation_states.dart';

class ReservationTicket extends StatefulWidget {
   ReservationTicket({super.key,
   required this.countSeates,
     required this.busId,
     required this.tripTypeId,
     required this.to,
     required this.from,
     required this.oneTripId
   });
List<num> countSeates ;
int busId;
String tripTypeId;
   String from;
   String to;
   int oneTripId;
  @override
  State<ReservationTicket> createState() => _ReservationTicketState();
}

class _ReservationTicketState extends State<ReservationTicket> {
  @override
  void initState() {
    print("tripTypeId${widget.tripTypeId}${widget.to}${widget.from}${widget.countSeates}${widget.busId}   ${widget.oneTripId}");

    super.initState();
  }
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
                   const  Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 15),
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
                         const Text("#55454",
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
                            padding:const EdgeInsets.symmetric(horizontal: 10),
                            width: sizeWidth *0.45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.primaryColor
                            ),
                            child:const Text(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          ContainerWidget(
                            color: Colors.transparent,
                            height: 0.01,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextWidget(text: widget.from,fontSize: 30,),
                          )

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextWidget(text: "Hurghada, Al Ahyaa",fontSize: 15,),
                          )

                        ],
                      ),
                    ),
                    SizedBox(height: sizeHeight *0.015,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          ContainerWidget(
                            color: AppColors.primaryColor,
                            height: 0.013,
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: sizeHeight *0.015,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          ContainerWidget(
                            color: AppColors.primaryColor,
                            height: 0.025,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextWidget(text: "To",fontSize: 15,color: AppColors.primaryColor,),
                          )

                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextWidget(text: widget.to,fontSize: 30,),
                        )

                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 42),
                          child: TextWidget(text: "Cairo, Tahrir",fontSize: 15,),
                        )

                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          BlocListener(
               bloc: BlocProvider.of<ReservationCubit>(context),
               listener: (context,state){
                 if (state is GetReservationLoadingState) {
                   Constants.showLoadingDialog(context);
                 }else if(state is GetAdReservationLoadedState){
                   Constants.hideLoadingDialog(context);
                 }else if(state is GetAdReservationErrorState){
                   Constants.hideLoadingDialog(context);
                   Constants.showDefaultSnackBar(context: context, text: state.mas!);
                 }
               },
            child: InkWell
              (
                onTap: (){
                  BlocProvider.of<ReservationCubit>(context).addReservation(
                      seatIdsOneTrip: widget.countSeates,
                      custId: widget.busId,
                      oneTripID: widget.oneTripId.toString());

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Constants.customButton(text: "Payment",color: AppColors.primaryColor),
                )),
          ),
        ],
      ),
    );
  }
}
