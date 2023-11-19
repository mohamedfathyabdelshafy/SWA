import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/icon_back.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../main.dart';
import '../../data/models/BusSeatsModel.dart';
import '../widgets/bus_seat_widget/seat_layout_model.dart';
import '../widgets/bus_seat_widget/seat_layout_widget.dart';

class BusLayoutScreen extends StatefulWidget {
   BusLayoutScreen({super.key,required this.to,required this.from});
String from;
String to;
  @override
  State<BusLayoutScreen> createState() => _BusLayoutScreenState();
}

class _BusLayoutScreenState extends State<BusLayoutScreen> {
  SeatDetails? selectedSeats;
  BusSeatsModel? busSeatsModel;
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl())) ;
  int unavailable=0 ;
@override

  void initState() {
  // busLayoutRepo?.getBusSeatsData();
  get();
   super.initState();
  }
  void get()async{
    await busLayoutRepo?.getBusSeatsData().then((value){
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
    double sizeWidth = context.width;
    

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading:iconBack(context),
        backgroundColor: Colors.black,
      ),
      body: Column(
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
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 15),
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
                      margin: EdgeInsetsDirectional.symmetric(horizontal: 12),
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
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "bold",
                            color: Colors.white
                          ),
                        ),
                        Text(
                          widget.to,
                          style: TextStyle(
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

                        Text(

                              'Available',
                          style: const TextStyle(
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
                        SizedBox(height: 20),
                        Text(
                         'Selected',
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "regular",
                            color: Colors.white
                          ),
                        ),
                        Text(
                          "03",
                          style:  TextStyle(
                            fontSize: 60,
                            fontFamily: "black",
                            color: Color(0xff5332F7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Unavailable',
                          style: const TextStyle(
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
                                  if (seatState == SeatState.selected) {
                                    selectedSeats = seat;
                                    busSeatsModel?.busSeatDetails?.busDetails?.rowList
                                        ?.forEach((element) {
                                      element.seats.forEach((element) {
                                        if (element.seatBusID != seat.seatBusID &&
                                            element.seatState == SeatState.selected) {
                                          print("kjbnljkblnkn");
                                          element.seatState =
                                              SeatState.available;
                                        }
                                      });
                                    });
                                  } else {
                                    selectedSeats = null;
                                    busSeatsModel?.busSeatDetails?.busDetails?.rowList?[rowI]
                                        .seats[colI]
                                        .seatState =
                                        SeatState.available;
                                    // selectedSeats.remove(SeatNumber(rowI: rowI, colI: colI));
                                  }
                                  setState(() {});
                                },
                                stateModel:
                                SeatLayoutStateModel(
                                  rows: busSeatsModel?.busSeatDetails?.busDetails?.rowList?.length ??0,
                                  cols:busSeatsModel?.busSeatDetails?.busDetails?.totalColumn ??
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
          InkWell
            (
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const ReservationTicket();
                }));
              },
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Constants.customButton(text: "confirm",color: AppColors.primaryColor),
          ))
        ],
      ),
    );
  }
}
