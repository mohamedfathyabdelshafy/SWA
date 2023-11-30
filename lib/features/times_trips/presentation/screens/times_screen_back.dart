import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout_back.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';
import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../data/models/TimesTripsResponsedart.dart';

// ignore: must_be_immutable
class TimesScreenBack extends StatefulWidget {
  TimesScreenBack(
      {super.key,
      required this.tripListBack,
      required this.tripTypeId,
      required this.countSeats,
      required this.price,
      this.user});
  List<TripListBack> tripListBack;
  String tripTypeId;
  List<dynamic> countSeats;
  double price;
  User? user;

  @override
  State<TimesScreenBack> createState() => _TimesScreenBackState();
}

class _TimesScreenBackState extends State<TimesScreenBack> {
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
                  height: sizeHeight * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: sizeHeight * 0.10,
                      ),
                      SvgPicture.asset(
                        "assets/images/Swa Logo.svg",
                        height: sizeHeight * 0.06,
                        width: sizeWidth * 0.06,
                      ),
                      SizedBox(
                        height: sizeHeight * 0.15,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: widget.tripListBack.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  CacheHelper.setDataToSharedPref(
                                      key: 'numberTrip2',
                                      value: widget
                                          .tripListBack[index].tripNumber);
                                  CacheHelper.setDataToSharedPref(
                                      key: 'elite2',
                                      value: widget
                                          .tripListBack[index].serviceType);
                                  CacheHelper.setDataToSharedPref(
                                      key: 'accessBusTime2',
                                      value: widget
                                          .tripListBack[index].accessBusTime);
                                  CacheHelper.setDataToSharedPref(
                                      key: 'lineName2',
                                      value:
                                          widget.tripListBack[index].lineName);
                                  CacheHelper.setDataToSharedPref(
                                      key: 'tripOneId',
                                      value:
                                          widget.tripListBack[index].tripId ??
                                              0);

                                  CacheHelper.setDataToSharedPref(
                                      key: 'tripRoundId',
                                      value: widget.tripListBack[index].tripId
                                          .toString());

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<LoginCubit>(
                                                      create: (context) =>
                                                          sl<LoginCubit>()),
                                                  BlocProvider<TimesTripsCubit>(
                                                    create: (context) =>
                                                        TimesTripsCubit(),
                                                  )
                                                ],
                                                // Replace with your actual cubit creation logic
                                                child: BusLayoutScreenBack(
                                                  to: widget.tripListBack[index]
                                                          .to ??
                                                      "",
                                                  from: widget
                                                          .tripListBack[index]
                                                          .from ??
                                                      "",
                                                  triTypeId: widget.tripTypeId,
                                                  cachCountSeats1:
                                                      widget.countSeats,
                                                  price: widget.price,
                                                  user: widget.user,
                                                  tripId: widget
                                                      .tripListBack[index]
                                                      .tripId!,
                                                ))),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                widget
                                                    .tripListBack[index].from!,
                                                style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                          Text(
                                              widget
                                                  .tripListBack[index].emptySeat
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              widget
                                                  .tripListBack[index].lineName
                                                  .toString(),
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 20)),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            width: sizeWidth * 0.62,
                                            child: const Divider(
                                              color: Colors.white,
                                              thickness:
                                                  2, // Adjust the thickness of the divider
                                              // height: 100,
                                              // Adjust the height of the divider
                                            ),
                                          ),
                                          Text(
                                              widget.tripListBack[index]
                                                  .serviceType
                                                  .toString(),
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                widget.tripListBack[index]
                                                    .accessBusTime!
                                                    .substring(0, 5),
                                                style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                          Text(
                                              "${widget.tripListBack[index].price!.toString()}.LE",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 18,
                                                  fontFamily: "bold")),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
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
