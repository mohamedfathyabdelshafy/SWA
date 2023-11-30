import 'package:flutter/cupertino.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_model.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_widget.dart';

import '../../../data/models/BusSeatsModel.dart';

class SeatLayoutWidget extends StatelessWidget {
  final SeatLayoutStateModel stateModel;
  final void Function(
          int rowI, int colI, SeatState currentState, SeatDetails seat)
      onSeatStateChanged;
  final double seatHeight;

  const SeatLayoutWidget({
    Key? key,
    required this.stateModel,
    required this.onSeatStateChanged,
    required this.seatHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(children: [
        ...List<int>.generate(stateModel.rows, (rowI) => rowI)
            .map<Row>(
              (rowI) => Row(
                children: [
                  ...List<int>.generate(stateModel.cols, (colI) => colI)
                      .map<SeatWidget>((colI) {
                    return SeatWidget(
                      model: SeatModel(
                        // seatState: stateModel.currentSeats[rowI][colI].getSeatState,
                        seat: stateModel.currentSeats[rowI][colI],
                        text: stateModel.currentSeats[rowI][colI].seatNo
                            .toString(),
                        rowI: rowI,
                        colI: colI,
                        seatSvgSize: stateModel.seatSvgSize,
                        pathSelectedSeat: stateModel.pathSelectedSeat,
                        pathDisabledSeat: stateModel.pathDisabledSeat,
                        pathSoldSeat: stateModel.pathSoldSeat,
                        pathUnSelectedSeat: stateModel.pathUnSelectedSeat,
                        seatLayoutStateModel: stateModel,
                      ),
                      onSeatStateChanged: onSeatStateChanged,
                      seatHeight: seatHeight,
                    );
                  }).toList()
                ],
              ),
            )
            .toList()
      ]),
    );
  }
}
