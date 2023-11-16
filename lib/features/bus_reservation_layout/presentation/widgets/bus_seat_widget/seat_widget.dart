
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/utils/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    // seatState = widget.model.seat.seatState;
    rowI = widget.model.rowI;
    colI = widget.model.colI;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.seat.seatState != null) {
      return SizedBox(
        height: widget.seatHeight,
        child: InkWell(
          onTap: () {
            print("GestureDetector ${widget.model.seat.seatState}  ${widget.model.seat.seatBusID}");
              switch (widget.model.seat.seatState) {
                case SeatState.selected:
                  {
                    // setState(() {
                    widget.model.seat.seatState = SeatState.available;
                    widget.onSeatStateChanged(
                        rowI, colI, SeatState.available, widget.model.seat);
                    // });
                  }
                  break;
                case SeatState.available:
                  {
                    // setState(() {
                    widget.model.seat.seatState = SeatState.selected;
                    widget.onSeatStateChanged(
                        rowI, colI, SeatState.selected, widget.model.seat);
                    // });
                  }
                  break;
                case SeatState.sold:
                case SeatState.empty:
                default:
                  {}
                  break;
              }

          },
          child: widget.model.seat.seatState != SeatState.empty
              ? Container(
                  height: 17,
                  width: 27,
                  margin: const EdgeInsets.only(left: 2, right: 2, bottom: 7),
                  child: Stack(
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          _getSvgPath(widget.model.seat.seatState!),
                          height: 20,
                          width: 27,
                          color:
                              Colors.red,
                              // : widget.model.seat.seatState == SeatState.sold
                              //     ? Colors.grey
                              //     : widget.model.seat.seatState ==
                              //             SeatState.available
                              //         ? AppColors.yellow2
                              //         : widget.model.seat.seatState ==
                              //                 SeatState.selected
                              //             ? AppColors.blue
                              //             : null,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(child: Text(widget.model.text))
                    ],
                  ),
                )
              : SizedBox(
                  height: widget.seatHeight * .1,
                  width: 30,
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
