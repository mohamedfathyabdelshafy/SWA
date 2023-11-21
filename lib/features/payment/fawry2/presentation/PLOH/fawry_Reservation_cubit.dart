import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/payment/fawry/presentation/cubit/fawry_cubit.dart';

import '../../../../../main.dart';
import '../../../../bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import '../../../select_payment/domain/entities/payment_message_response.dart';
import 'fawry_Reservation_states.dart';

class FawryReservation extends Cubit<FawryReservationState>{
  FawryReservation():super(FawryReservationInitial());
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: sl());

  Future<PaymentMessageResponse?>addReservation({
    required List<dynamic> seatIdsOneTrip,
    List<dynamic>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID,
    required String paymentMethodID,
    required String paymentTypeID,
    double? amount,
  })async {
    try{
      emit(FawryLoadingReservationState());
      final res = await busLayoutRepo.addReservation(
          custId: custId,
          seatIdsRoundTrip: seatIdsRoundTrip,
          roundTripID: roundTripID,
          oneTripID: oneTripID,
          paymentMethodID: "2",
          paymentTypeID: "68",
          seatIdsOneTrip: seatIdsOneTrip,
          amount: amount,);
      if(res.message != null){
        emit(FawryLoadedReservationState(paymentMessageResponse: res));
      }else{
        emit(FawryErrorReservationState(error: res.message! ));
      }
    }catch (e){
      emit(FawryErrorReservationState(error: e.toString()));
    }
  }

}