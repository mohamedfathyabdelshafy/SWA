import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/icon_back.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_states.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/screens/times_screen.dart';

import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../main.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../../times_trips/data/models/TimesTripsResponsedart.dart';
import '../../../times_trips/presentation/PLOH/times_trips_cubit.dart';
import '../../../times_trips/presentation/screens/times_screen_back.dart';
import '../../data/models/BusSeatsModel.dart';
import '../widgets/bus_seat_widget/seat_layout_model.dart';
import '../widgets/bus_seat_widget/seat_layout_widget.dart';

class BusLayoutScreen extends StatefulWidget {
  BusLayoutScreen(
      {super.key,
      required this.to,
      required this.from,
      required this.triTypeId,
      this.tripListBack,
      required this.price,
      this.user,
      required this.tripId});
  String from;
  String to;
  String triTypeId;
  List<TripListBack>? tripListBack;
  double price;
  User? user;
  int tripId;
  @override
  State<BusLayoutScreen> createState() => _BusLayoutScreenState();
}

class _BusLayoutScreenState extends State<BusLayoutScreen> {
  SeatDetails? selectedSeats;
  BusSeatsModel? busSeatsModel;
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl()));
  int unavailable = 0;
  List<num> countSeats = [];
  List<dynamic>? cachCountSeats;
  int countSeatesNum = 0;
  @override
  void initState() {
    print("tripTypeId${widget.triTypeId}}");
    // busLayoutRepo?.getBusSeatsData();
    get();
    super.initState();
  }

  void get() async {
    print("ttttttttttttt${widget.tripId}");
    busLayoutRepo.getBusSeatsData(tripId: widget.tripId).then((value) async {
      busSeatsModel = await value;
      if (busSeatsModel != null) {
        unavailable = await busSeatsModel!.busSeatDetails!.totalSeats! -
            busSeatsModel!.busSeatDetails!.emptySeats!;
        setState(() {});
      }
    });
    print(
        "busSeatsmodel${busSeatsModel?.busSeatDetails?.busDetails?.totalRow}");
    print("unavailable$unavailable");
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: iconBack(context),
        backgroundColor: Colors.black,
        title: Text(
          "Select seats",
          style: TextStyle(
              color: AppColors.white, fontSize: 34, fontFamily: "regular"),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10)),
            height: 87,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 4,
                      margin:
                          const EdgeInsetsDirectional.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomStart,
                          colors: [AppColors.white, AppColors.yellow2],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          widget.from,
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "bold",
                              color: Colors.white),
                        ),
                        Text(
                          widget.to,
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "bold",
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.sizeOf(context).height - 180,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "regular",
                            color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          busSeatsModel?.busSeatDetails?.emptySeats
                                  .toString() ??
                              "",
                          style: TextStyle(
                              fontSize: 45,
                              fontFamily: 'black',
                              color: AppColors.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Selected',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "regular",
                            color: Colors.white),
                      ),
                      Text(
                        countSeatesNum.toString(),
                        style: const TextStyle(
                          fontSize: 45,
                          fontFamily: "black",
                          color: Color(0xff5332F7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Unavailable',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "regular",
                            color: Colors.white),
                      ),
                      Text(
                        unavailable.toString(),
                        style: const TextStyle(
                            fontSize: 45,
                            fontFamily: "black",
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          cachCountSeats =
                              CacheHelper.getDataToSharedPref(key: 'countSeats')
                                  ?.map((e) => int.tryParse(e) ?? 0)
                                  .toList();
                          print("countSeats2Bassant$cachCountSeats");
                          if (countSeats == null ||
                              countSeatesNum == null ||
                              busSeatsModel == null) {
                            Constants.showDefaultSnackBar(
                                context: context,
                                text: "please select your seats");
                          } else {
                            if (widget.triTypeId == "1") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlocProvider<LoginCubit>(
                                          create: (context) => sl<LoginCubit>(),
                                          child: ReservationTicket(
                                            price: widget.price,
                                            countSeates: countSeats,
                                            busId: busSeatsModel!
                                                .busSeatDetails!
                                                .busDetails!
                                                .busID!,
                                            tripTypeId: "1",
                                            from: widget.from,
                                            to: widget.to,
                                            oneTripId: busSeatsModel!
                                                .busSeatDetails!.tripId!,
                                            countSeats1: cachCountSeats!,
                                            user: widget.user,
                                          )),
                                ),
                              );
                            } else if (widget.triTypeId == "2") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return BlocProvider<TimesTripsCubit>(
                                      create: (context) => TimesTripsCubit(),
                                      // Replace with your actual cubit creation logic
                                      child: TimesScreenBack(
                                        price: widget.price,
                                        countSeats: cachCountSeats!,
                                        tripListBack: widget.tripListBack!,
                                        tripTypeId: widget.triTypeId,
                                        user: widget.user,
                                      ));
                                }),
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "choose seats",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "bold",
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: sizeHeight * 0.75,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27),
                          child: Container(
                              width: 240,
                              height: sizeHeight * .23,
                              child: SvgPicture.asset(
                                'assets/images/bus_body.svg',
                                fit: BoxFit.fill,
                              )),
                        ),
                        Positioned(
                          top: sizeHeight * .23 - 80,
                          right: 50,
                          bottom: 0,
                          child: SizedBox(
                            child: SeatLayoutWidget(
                              seatHeight: sizeHeight * .040,
                              onSeatStateChanged:
                                  (rowI, colI, seatState, seat) {
                                if (seatState == SeatState.selected) {
                                  countSeats.add(busSeatsModel!
                                      .busSeatDetails!
                                      .busDetails!
                                      .rowList![rowI]
                                      .seats[colI]
                                      .seatBusID!);
                                  print("countSeats${countSeats}");
                                  countSeatesNum = countSeats.length;
                                  CacheHelper.setDataToSharedPref(
                                      key: 'countSeats', value: countSeats);

                                  setState(() {});
                                } else {
                                  selectedSeats = null;
                                  busSeatsModel
                                      ?.busSeatDetails
                                      ?.busDetails
                                      ?.rowList?[rowI]
                                      .seats[colI]
                                      .seatState = SeatState.available;
                                  countSeats.remove(busSeatsModel!
                                      .busSeatDetails!
                                      .busDetails!
                                      .rowList![rowI]
                                      .seats[colI]
                                      .seatBusID!);
                                  countSeatesNum = countSeats.length;
                                  setState(() {});
                                }

                                // if (seatState == SeatState.selected) {
                                //   selectedSeats = seat;
                                //   busSeatsModel?.busSeatDetails?.busDetails?.rowList
                                //       ?.forEach((element) {
                                //     element.seats.forEach((element) {
                                //       if (element.seatBusID != seat.seatBusID &&
                                //           element.seatState == SeatState.selected) {
                                //         print("kjbnljkblnkn");
                                //         element.seatState =
                                //             SeatState.available;
                                //       }
                                //     });
                                //   });
                                // } else {
                                //   selectedSeats = null;
                                //   busSeatsModel?.busSeatDetails?.busDetails?.rowList?[rowI]
                                //       .seats[colI]
                                //       .seatState =
                                //       SeatState.available;
                                //   // selectedSeats.remove(SeatNumber(rowI: rowI, colI: colI));
                                // }
                                // setState(() {});
                              },
                              stateModel: SeatLayoutStateModel(
                                rows: busSeatsModel?.busSeatDetails?.busDetails
                                        ?.rowList?.length ??
                                    0,
                                cols: busSeatsModel?.busSeatDetails?.busDetails
                                        ?.totalColumn ??
                                    5,
                                seatSvgSize: 35,
                                pathSelectedSeat:
                                    'assets/images/unavailable_seats.svg',
                                pathDisabledSeat:
                                    'assets/images/unavailable_seats.svg',
                                pathSoldSeat:
                                    'assets/images/unavailable_seats.svg',
                                pathUnSelectedSeat:
                                    'assets/images/unavailable_seats.svg',
                                currentSeats: List.generate(
                                  busSeatsModel?.busSeatDetails?.busDetails
                                          ?.rowList?.length ??
                                      0, // Number of rows based on totalSeats
                                  (row) => busSeatsModel!.busSeatDetails!
                                      .busDetails!.rowList![row].seats,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // BlocListener(
          //    bloc: BlocProvider.of<ReservationCubit>(context),
          //    listener: (context,state){
          //      if (state is GetReservationLoadingState) {
          //        Constants.showLoadingDialog(context);
          //      }else if(state is GetAdReservationLoadedState){
          //        Constants.hideLoadingDialog(context);
          //        Navigator.push(context, MaterialPageRoute(builder: (context){
          //          return ReservationTicket();
          //        }));
          //      }else if(state is GetAdReservationErrorState){
          //        Constants.hideLoadingDialog(context);
          //        Constants.showDefaultSnackBar(context: context, text: state.mas!);
          //      }
          //    },
          // child:

          // )
        ],
      ),
    );
  }
}
