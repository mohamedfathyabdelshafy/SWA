import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/icon_back.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';
import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../main.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../data/models/BusSeatsModel.dart';
import '../widgets/bus_seat_widget/seat_layout_model.dart';
import '../widgets/bus_seat_widget/seat_layout_widget.dart';

class BusLayoutScreenBack extends StatefulWidget {
  BusLayoutScreenBack({super.key,
      required this.to,
      required this.from,
      required this.triTypeId,
      required this.cachCountSeats1,
      required this.price,
    this.user
  });
  String from;
  String to;
  String triTypeId;
  List<dynamic> cachCountSeats1;
  double price;
  User? user;

  @override
  State<BusLayoutScreenBack> createState() => _BusLayoutScreenBackState();
}

class _BusLayoutScreenBackState extends State<BusLayoutScreenBack> {
  SeatDetails? selectedSeats;
  BusSeatsModel? busSeatsModel;
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl())) ;
  int unavailable=0 ;
  List<num> countSeats = [];
  List<dynamic>? cachCountSeats2;

  int countSeatesNum = 0;
  @override
  void initState() {
    print("tripTypeId${widget.triTypeId}}");
    // busLayoutRepo?.getBusSeatsData();
    get();
    super.initState();
  }
  void get()async{
    await busLayoutRepo.getBusSeatsData().then((value){
      busSeatsModel =  value;
      if(busSeatsModel != null) {
        unavailable = busSeatsModel!.busSeatDetails!.totalSeats! - busSeatsModel!.busSeatDetails!.emptySeats!;
        setState(() {
        });
      }
    });
    print("busSeatsmodel${busSeatsModel?.busSeatDetails?.busDetails?.totalRow}");
    print("unavailable$unavailable");
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading:iconBack(context),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Text(
                "Select seats",
                style: TextStyle(color: AppColors.white,fontSize: 34,fontFamily:"regular"),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              height: sizeHeight * 0.12,
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: sizeHeight * 0.07 ,
                        width: 4,
                        margin: const EdgeInsetsDirectional.symmetric(horizontal: 12),
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
                            style:const TextStyle(
                                fontSize: 18,
                                fontFamily: "bold",
                                color: Colors.white
                            ),
                          ),
                          Text(
                            widget.to,
                            style:const TextStyle(
                                fontSize: 18,
                                fontFamily: "bold",
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: sizeHeight * 0.60,
              child: ListView(
                  children: [Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [

                            const  Text(
                              'Available',
                              style:  TextStyle(
                                  fontSize: 20,
                                  fontFamily: "regular",
                                  color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Text(
                                busSeatsModel?.busSeatDetails?.emptySeats.toString()??"",
                                style:TextStyle(
                                    fontSize: 60,
                                    fontFamily: 'black',
                                    color: AppColors.primaryColor),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Selected',
                              style:  TextStyle(
                                  fontSize: 20,
                                  fontFamily: "regular",
                                  color: Colors.white
                              ),
                            ),
                            Text(
                              countSeatesNum.toString(),
                              style:const  TextStyle(
                                fontSize: 60,
                                fontFamily: "black",
                                color: Color(0xff5332F7),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const   Text(
                              'Unavailable',
                              style:  TextStyle(
                                  fontSize: 20,
                                  fontFamily: "regular",
                                  color: Colors.white
                              ),
                            ),
                            Text(

                              unavailable .toString(),
                              style: const TextStyle(
                                  fontSize: 60,
                                  fontFamily: "black",
                                  color: Colors.grey),
                            ),

                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: sizeHeight * 0.60,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 27),
                                child: SizedBox(
                                    width: 240,
                                    height: sizeHeight * .23,
                                    child: SvgPicture.asset(
                                      'assets/images/bus_body.svg',
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              Positioned(
                                top: sizeHeight * .10 * .52,
                                right: 51,
                                bottom: 0,
                                child: SizedBox(
                                  height: sizeHeight * .55,
                                  child: SeatLayoutWidget(
                                    seatHeight: sizeHeight * .047,
                                    onSeatStateChanged: (rowI, colI,
                                        seatState, seat) {
                                      if(seatState == SeatState.selected){
                                        countSeats.add( busSeatsModel!.busSeatDetails!.busDetails!.rowList![rowI].seats[colI].seatBusID!);
                                        print("countSeats${countSeats}");
                                        countSeatesNum =countSeats.length;
                                        CacheHelper.setDataToSharedPref(key: 'countSeats2',
                                            value: countSeats
                                        );

                                        setState(() {

                                        });
                                      } else {
                                        selectedSeats = null;
                                        busSeatsModel
                                            ?.busSeatDetails
                                            ?.busDetails
                                            ?.rowList?[rowI]
                                            .seats[colI]
                                            .seatState = SeatState.available;
                                        countSeats.remove(busSeatsModel!.busSeatDetails!.busDetails!.rowList![rowI].seats[colI].seatBusID!);
                                        countSeatesNum =countSeats.length;
                                        setState(() {

                                        });

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
                                    stateModel:
                                    SeatLayoutStateModel(
                                      rows: busSeatsModel?.busSeatDetails?.busDetails?.rowList?.length ??0,
                                      cols:busSeatsModel?.busSeatDetails?.busDetails?.totalColumn ??
                                          5,
                                      seatSvgSize: 35,
                                      pathSelectedSeat:
                                      'assets/images/unavailable_sets.svg',
                                      pathDisabledSeat:
                                      'assets/images/unavailable_seats.svg',
                                      pathSoldSeat:
                                      'assets/images/unavailable_seats.svg',
                                      pathUnSelectedSeat:
                                      'assets/images/unavailable_seats.svg',
                                      currentSeats: List.generate(
                                        busSeatsModel?.busSeatDetails?.busDetails?.rowList?.length ?? 0, // Number of rows based on totalSeats
                                            (row) => busSeatsModel!.busSeatDetails!.busDetails!.rowList![row].seats,
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
                  ),]
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
            InkWell
              (
                onTap: (){
                  cachCountSeats2 = CacheHelper.getDataToSharedPref(key: 'countSeats2')?.map((e) => int.tryParse(e) ?? 0).toList();
                  print("countSeats3Bassant$cachCountSeats2");
                  print("countSeats4Bassant${widget.cachCountSeats1}");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return  ReservationTicket(
                              price: widget.price,
                              countSeates: countSeats,
                              busId: busSeatsModel!.busSeatDetails!.busDetails!.busID!,
                              tripTypeId:"2",
                              from: widget.from,
                              to: widget.to,
                              oneTripId: busSeatsModel!.busSeatDetails!.tripId!,
                              countSeats1: widget.cachCountSeats1,
                              countSeats2: cachCountSeats2,
                              user: widget.user,

                        );
                      }),
                    );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Constants.customButton(text: "Choose Seats",color: AppColors.primaryColor),
                )),
            // )
          ],
        ),
      ),
    );
  }
}
