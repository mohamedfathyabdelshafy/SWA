import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/icon_back.dart';
import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsEditModel.dart';
import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsModel.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_states.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_widget.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/data/models/TimesTripsResponsedart.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';

class BusLayoutEditScreen extends StatefulWidget {
  BusLayoutEditScreen(
      {super.key,
      required this.to,
      required this.from,
      this.user,
      required this.reservationID});
  String from;
  String to;

  User? user;
  int reservationID;
  @override
  State<BusLayoutEditScreen> createState() => _BusLayoutScreenState();
}

class _BusLayoutScreenState extends State<BusLayoutEditScreen> {
  SeatDetails? selectedSeats;
  BusSeatsEditModel? busSeatsModel;
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl()));
  int unavailable = 0;
  List<num> countSeats = [];
  List<num> Seatsnumbers = [];

  List<dynamic> cachCountSeats = [];
  int countSeatesNum = 0;
  @override
  void initState() {
    BlocProvider.of<BusLayoutCubit>(context)
        .getBusSeatsedit(reservationID: widget.reservationID);
    // busLayoutRepo?.getBusSeatsData();
    get();
    super.initState();
  }

  void get() async {
    print("DDttttttttttttt${widget.reservationID}");
    busLayoutRepo
        .getReservationSeatsData(reservationID: widget.reservationID)
        .then((value) async {
      busSeatsModel = await value;

      if (busSeatsModel != null) {
        unavailable = await busSeatsModel!.message.totalSeats! -
            busSeatsModel!.message.emptySeats;

        for (int i = 0; i < busSeatsModel!.message.busDetailsVm.totalRow; i++) {
          for (int j = 0;
              j < busSeatsModel!.message.busDetailsVm.rowList[i].seats.length;
              j++) {
            if (busSeatsModel!
                    .message.busDetailsVm.rowList[i].seats[j].isReserved ==
                true) {
              busSeatsModel!.message.busDetailsVm.rowList[i].seats[j]
                  .seatState = SeatState.sold;
              for (int n = 0;
                  n < busSeatsModel!.message.mySeatListId.length;
                  n++) {
                countSeatesNum = busSeatsModel!.message.mySeatListId.length;
                if (busSeatsModel!
                        .message.busDetailsVm.rowList[i].seats[j].seatBusID ==
                    busSeatsModel!.message.mySeatListId[n]) {
                  busSeatsModel!.message.busDetailsVm.rowList[i].seats[j]
                      .seatState = SeatState.selected;
                  countSeats.add(busSeatsModel!.message.mySeatListId[n]);

                  Seatsnumbers.add(busSeatsModel!
                      .message.busDetailsVm.rowList[i].seats[j].seatNo!);

                  setState(() {});
                }
              }
            }
          }
        }

        setState(() {});
      }
    });

    print("unavailable$unavailable");
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener(
        bloc: BlocProvider.of<BusLayoutCubit>(context),
        listener: (BuildContext context, state) {
          if (state is GetAdReservationLoadedState) {
            Constants.showDefaultSnackBar(
                context: context,
                color: Colors.green,
                text: state.reservationResponse.toString());

            Navigator.pop(context);
          } else if (state is ReservationErrorState) {
            log('message');
            Constants.showDefaultSnackBar(
                context: context,
                color: Colors.red,
                text: state.message.toString());

            Navigator.pop(context);
          }
        },
        child: BlocBuilder<BusLayoutCubit, ReservationState>(
          builder: (context, state) {
            if (state is BusSeatsLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: sizeHeight * 0.06,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Ticketreservation.Seatsnumbers1.clear();
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.primaryColor,
                        size: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      LanguageClass.isEnglish ? "Select seats" : "حدد كراسيك",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          fontFamily: "roman"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 4,
                              margin: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  begin: AlignmentDirectional.topStart,
                                  end: AlignmentDirectional.bottomStart,
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.primaryColor
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.from,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: "bold",
                                      color: Colors.black),
                                ),
                                Text(
                                  widget.to,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: "bold",
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 250,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text(
                                LanguageClass.isEnglish
                                    ? 'Available'
                                    : 'المتاح',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "regular",
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  busSeatsModel?.message.emptySeats
                                          .toString() ??
                                      " ",
                                  style: TextStyle(
                                      fontSize: 45,
                                      fontFamily: 'black',
                                      color: AppColors.primaryColor),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                LanguageClass.isEnglish
                                    ? 'Selected'
                                    : 'تم تحديده',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "regular",
                                    color: Colors.black),
                              ),
                              Text(
                                Seatsnumbers.length.toString(),
                                style: const TextStyle(
                                  fontSize: 45,
                                  fontFamily: "black",
                                  color: Color(0xff5332F7),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                LanguageClass.isEnglish
                                    ? 'Unavailable'
                                    : 'غير متاح',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "regular",
                                    color: Colors.black),
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
                                  if (Seatsnumbers.isNotEmpty) {
                                    log(countSeats.toString());

                                    BlocProvider.of<BusLayoutCubit>(context)
                                        .SaveticketEdit(
                                            reservationID: widget.reservationID,
                                            Seatsnumbers: countSeats,
                                            price: busSeatsModel
                                                ?.message.seatPrice);
                                  } else {
                                    Constants.showDefaultSnackBar(
                                        color: Colors.red,
                                        context: context,
                                        text: LanguageClass.isEnglish
                                            ? 'Select Seats'
                                            : 'اختر الكراسي');
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
                                      LanguageClass.isEnglish ? "Save" : "تم",
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      height: sizeHeight * 0.23,
                                      child: SvgPicture.asset(
                                        'assets/images/bus_body.svg',
                                        fit: BoxFit.fill,
                                      )),
                                ),
                                Positioned(
                                  top: sizeHeight * 0.23 - 73,
                                  right: 30,
                                  left: 30,
                                  bottom: 0,
                                  child: SizedBox(
                                    child: SeatLayoutWidget(
                                      seatHeight: sizeHeight * .036,
                                      onSeatStateChanged:
                                          (rowI, colI, seatState, seat) {
                                        print("set ");
                                        print("seatstate ");
                                        print("rowI , column1 ");
                                        if (seatState == SeatState.selected) {
                                          print("I am here");
                                          countSeats.add(busSeatsModel!
                                              .message
                                              .busDetailsVm
                                              .rowList![rowI]
                                              .seats[colI]
                                              .seatBusID!);
                                          Seatsnumbers.add(busSeatsModel!
                                              .message
                                              .busDetailsVm
                                              .rowList![rowI]
                                              .seats[colI]
                                              .seatNo!);
                                          print("countSeats");
                                          countSeatesNum = countSeats.length;
                                          CacheHelper.setDataToSharedPref(
                                              key: 'countSeats',
                                              value: countSeats);

                                          setState(() {});
                                        } else {
                                          print("I am there");
                                          selectedSeats = null;
                                          busSeatsModel!
                                              .message
                                              .busDetailsVm
                                              .rowList[rowI]
                                              .seats[colI]
                                              .seatState = SeatState.available;
                                          countSeats.remove(busSeatsModel!
                                              .message
                                              .busDetailsVm
                                              .rowList![rowI]
                                              .seats[colI]
                                              .seatBusID!);
                                          Seatsnumbers.remove(busSeatsModel!
                                              .message
                                              .busDetailsVm
                                              .rowList![rowI]
                                              .seats[colI]
                                              .seatNo!);
                                          countSeatesNum = countSeats.length;
                                          setState(() {});
                                        }
                                      },
                                      stateModel: SeatLayoutStateModel(
                                        rows: busSeatsModel?.message
                                                .busDetailsVm.rowList.length ??
                                            0,
                                        cols: busSeatsModel?.message
                                                .busDetailsVm.totalColumn ??
                                            5,
                                        seatSvgSize: 35,
                                        pathSelectedSeat:
                                            'assets/images/unavailable_seats.svg',
                                        pathDisabledSeat:
                                            'assets/images/unavailable_seats.svg',
                                        pathSoldSeat:
                                            'assets/images/disabled_seats.svg',
                                        pathUnSelectedSeat:
                                            'assets/images/unavailable_seats.svg',
                                        currentSeats: List.generate(
                                          busSeatsModel?.message.busDetailsVm
                                                  .rowList.length ??
                                              0,
                                          // Number of rows based on totalSeats
                                          (row) => busSeatsModel!.message
                                              .busDetailsVm.rowList![row].seats,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
