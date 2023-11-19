import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import '../../data/models/TimesTripsResponsedart.dart';

// ignore: must_be_immutable
class TimesScreen extends StatefulWidget {
  TimesScreen({super.key,required this.tripList,required this.tripTypeId});
  List <TripList> tripList ;
  String tripTypeId;
  @override
  State<TimesScreen> createState() => _TimesScreenState();
}
class _TimesScreenState extends State<TimesScreen> {
  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity, // Take the full width of the screen
                  child: Image.asset(
                    "assets/images/oranaa.agency_85935_Ein_Sokhna_Sunset_5f6b0765-1585-4ef7-bb6a-484963505b20.png",
                    fit: BoxFit.cover,
                    // Maintain the aspect ratio
                  ),
                ),
                SizedBox(
                  height: sizeHeight *0.9,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height:sizeHeight *0.10 ,),
                      SvgPicture.asset(
                        "assets/images/Swa Logo.svg",
                        height: sizeHeight * 0.06,
                        width: sizeWidth *0.06,
                      ),
                      SizedBox(height:sizeHeight * 0.15,),

                      Expanded(
                        child: ListView.builder(
                            itemCount: widget.tripList.length,
                            itemBuilder:(context,index) {
                              return InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return BlocProvider<ReservationCubit>(
                                        create: (context) => ReservationCubit(), // Replace with your actual cubit creation logic
                                        child: BusLayoutScreen(
                                          to: widget.tripList[index].to ?? "",
                                          from: widget.tripList[index].from ?? "",
                                          triTypeId: widget.tripTypeId,
                                        ),
                                      );
                                    }),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                widget.tripList[index].from!,
                                                style: TextStyle(color: AppColors.white,fontSize:15 ),)
                                            ],
                                          ),
                                          Text(
                                              widget.tripList[index].emptySeat.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: AppColors.white,fontSize: 20 )),
                                        ],
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              widget.tripList[index].lineName.toString(),
                                              style: TextStyle(color: AppColors.white,fontSize: 20 )),
                                          Container(
                                            padding:const EdgeInsets.symmetric(horizontal: 20),
                                            width:sizeWidth *0.62,
                                            child: const Divider(
                                              color: Colors.white,
                                              thickness: 2, // Adjust the thickness of the divider
                                              // height: 100,
                                              // Adjust the height of the divider
                                            ),
                                          ),
                                          Text(
                                              widget.tripList[index].serviceType.toString(),
                                              style: TextStyle(color: AppColors.white,fontSize: 20 )),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                widget.tripList[index].to!,
                                                style: TextStyle(color: AppColors.white,fontSize:12 ),)
                                            ],
                                          ),
                                          Text(
                                              "${widget.tripList[index].price!.toString()}.LE",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: AppColors.primaryColor,fontSize: 20,fontFamily: "bold" )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                )
              ],

            ),

          ],
        ),
      ),

    );
  }
}
