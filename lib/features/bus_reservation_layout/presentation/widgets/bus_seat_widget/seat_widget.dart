import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_model.dart';

import '../../../data/models/BusSeatsModel.dart';

class SeatWidget extends StatefulWidget {
  final SeatModel model;
  final void Function(
          int rowI, int colI, SeatState currentState, SeatDetails seat)
      onSeatStateChanged;
  final double seatHeight;

  const SeatWidget({
    Key? key,
    required this.model,
    required this.onSeatStateChanged,
    required this.seatHeight,
  }) : super(key: key);

  @override
  State<SeatWidget> createState() => _SeatWidgetState();
}

class _SeatWidgetState extends State<SeatWidget> {
  int rowI = 0;
  int colI = 0;
  List<num> countSeats = [];
  List<SeatDetails> selectedSeats = []; // Add this line

  @override
  void initState() {
    super.initState();
    // seatState = widget.model.seat.seatState;
    rowI = widget.model.rowI;
    colI = widget.model.colI;

    log('atttt' + widget.model.rowI.toString());
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = context.width;

    if (widget.model.seat.seatState != null) {
      return SizedBox(
        height: widget.model.seatLayoutStateModel.rows < 7
            ? (widget.seatHeight + 25)
            : widget.seatHeight,
        child: InkWell(
          onTap: () {
            if (widget.model.seat.seatState == SeatState.empty) {
              return;
            } else if (widget.model.seat.seatState == SeatState.sold) {
              print("do nothing");
            } else if (widget.model.seat.seatState == SeatState.booked) {
              print("do nothing");
            } else {
              countSeats.add(widget.model.seat.seatBusID!);
              print("widget.model.seat.seatBusID${countSeats}");
              print(
                  "GestureDetector ${widget.model.seat.seatState}  ${widget.model.seat.seatBusID}");

              setState(() {
                if (widget.model.seat.seatState == SeatState.selected) {
                  widget.model.seat.seatState = SeatState.available;
                  selectedSeats.remove(widget.model.seat);
                } else {
                  widget.model.seat.seatState = SeatState.selected;
                  selectedSeats.add(widget.model.seat);
                }
                widget.onSeatStateChanged(rowI, colI,
                    widget.model.seat.seatState!, widget.model.seat);
              });
            }
          },
          child: widget.model.seat.seatState != SeatState.empty
              ? Container(
                  height: 17,
                  width: rowI < 7 ? sizeWidth / 11 : sizeWidth / 12,
                  margin: const EdgeInsets.only(left: 2, right: 2, bottom: 7),
                  child: Stack(
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          _getSvgPath(widget.model.seat.seatState!),
                          height: widget.seatHeight,
                          width: rowI < 7 ? sizeWidth / 10 : sizeWidth / 11,
                          color: widget.model.seat.seatState == SeatState.sold
                              ? Colors.grey
                              : widget.model.seat.seatState ==
                                      SeatState.available
                                  ? AppColors.primaryColor
                                  : widget.model.seat.seatState ==
                                          SeatState.selected
                                      ? Color(0xff5332F7)
                                      : widget.model.seat.seatState ==
                                              SeatState.booked
                                          ? Colors.amber
                                          : widget.model.seat.seatState ==
                                                  SeatState.sold
                                              ? Colors.grey
                                              : null,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                          child: Text(
                        widget.model.text,
                        style: fontStyle(
                            fontSize: 13,
                            fontFamily: FontFamily.bold,
                            color: Colors.white),
                      ))
                    ],
                  ),
                )
              : Container(
                  height: 17,
                  width: sizeWidth / 11,
                  margin: const EdgeInsets.only(left: 2, right: 2, bottom: 7),
                ),
        ),
      );
    }
    return const SizedBox();
  }

  String _getSvgPath(SeatState state) {
    switch (state) {
      case SeatState.available:
        {
          return widget.model.pathUnSelectedSeat;
        }
      case SeatState.selected:
        {
          return widget.model.pathSelectedSeat;
        }
      case SeatState.sold:
        {
          return widget.model.pathSoldSeat;
        }
      case SeatState.empty:
      default:
        {
          return widget.model.pathDisabledSeat;
        }
    }
  }
}
