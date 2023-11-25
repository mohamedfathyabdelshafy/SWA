import 'package:equatable/equatable.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';

import '../../../data/models/BusSeatsModel.dart';

class SeatModel extends Equatable {
  // final SeatState seatState;
  final int rowI;
  final int colI;
  final int seatSvgSize;
  final String pathSelectedSeat;
  final String pathUnSelectedSeat;
  final String pathSoldSeat;
  final String pathDisabledSeat;
  final String text;
  final SeatDetails seat;
  SeatLayoutStateModel seatLayoutStateModel;

  SeatModel({
    // required this.seatState,
    required this.rowI,
    required this.colI,
    this.seatSvgSize = 50,
    required this.pathSelectedSeat,
    required this.pathDisabledSeat,
    required this.pathSoldSeat,
    required this.pathUnSelectedSeat,
    required this.text,
    required this.seat,
    required this.seatLayoutStateModel,
  });

  @override
  List<Object?> get props => [
    // seatState,
    rowI,
    colI,
    seatSvgSize,
    pathSelectedSeat,
    pathDisabledSeat,
    pathSoldSeat,
    pathUnSelectedSeat,
  ];
}
