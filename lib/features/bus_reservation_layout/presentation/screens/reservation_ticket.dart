import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/Container_Widget.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/text_widget.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/screens/select_payment.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/icon_back.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../../sign_in/presentation/cubit/login_cubit.dart';

class ReservationTicket extends StatefulWidget {
  ReservationTicket(
      {super.key,
      required this.countSeates,
      required this.busId,
      required this.tripTypeId,
      required this.to,
      required this.from,
      required this.oneTripId,
      required this.countSeats1,
      this.countSeats2,
      required this.price,
      this.user});
  List<num> countSeates;
  int busId;
  String tripTypeId;
  String from;
  String to;
  int oneTripId;
  List<dynamic> countSeats1;
  List<dynamic>? countSeats2;
  double price;
  User? user;

  @override
  State<ReservationTicket> createState() => _ReservationTicketState();
}

class _ReservationTicketState extends State<ReservationTicket> {
  bool switch1 = false;
  bool accept = false;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
    });
    super.initState();
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
                      height: sizeHeight * 0.65,
                      width: sizeWidth * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
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
                                  horizontal: 15, vertical: 5),
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
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                              width: sizeWidth * 0.5,
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
                                      text: widget.from,
                                      fontSize: 25,
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
                                      text: widget.to,
                                      fontSize: 15,
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
                                    text: widget.to,
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
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.countSeats1.length,
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
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    ("EGP${widget.countSeats1!.length * widget.price}")
                                        .toString(),
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
                  widget.tripTypeId != null && widget.tripTypeId == "2"
                      ? Padding(
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                          text: "To",
                                          fontSize: 15,
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
                                          color: Colors.transparent,
                                          height: 0.01,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: TextWidget(
                                            text: widget.to,
                                            fontSize: 30,
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
                                          text: widget.from,
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
                                        itemCount: widget.countSeats2!.length,
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
                                          ("EGP${widget.countSeats2!.length * widget.price}")
                                              .toString(),
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
                      : SizedBox(),
                ],
              ),
            ),
          ),
          // ),

          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 20),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                    value: accept,
                    hoverColor: Colors.white,
                    checkColor: Colors.blue,
                    focusColor: Colors.white,
                    activeColor: Colors.white,
                    fillColor: MaterialStatePropertyAll(Colors.white),
                    onChanged: (value) {
                      setState(() {
                        accept = value!;
                      });
                    }),
                Text(
                  'Accept payment policy',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            ),
          ),
          InkWell(
              onTap: accept
                  ? () {
                      if (widget.user == null) {
                        Navigator.pushNamed(context, Routes.signInRoute);
                      } else {
                        int lenght = widget.countSeats2?.length ?? 0;
                        CacheHelper.setDataToSharedPref(
                          key: 'price',
                          value: lenght * widget.price +
                              widget.countSeats1.length * widget.price,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BlocProvider<ReservationCubit>(
                              create: (context) => ReservationCubit(),
                              child: SelectPaymentScreen2(user: widget.user),
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Constants.customButton(
                    text: "Payment",
                    color:
                        accept ? AppColors.primaryColor : AppColors.darkGrey),
              )),
        ],
      ),
    );
  }
}
